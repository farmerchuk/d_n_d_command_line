# game.rb

require_relative 'lib/helpers'
require_relative 'lib/player_list'
require_relative 'lib/player'
require_relative 'lib/area'
require_relative 'lib/location'
require_relative 'lib/event_handler'

require 'yaml'

require 'pry'

# Game logic

class DND
  include Helpers::Format

  def initialize
    @start = YAML.load_file('resources/initialize.yml')
    @players = PlayerList.new
    @current_player = nil
    @areas = {}
  end

  def run
    welcome
    generate_areas
    binding.pry
    create_players
    set_players_in_starting_area_and_location
    set_current_player

    loop do
      dm_describes_scene
      dm_selects_player_turn
      dm_describes_scene
      player_selects_action
      resolve_player_turn
    end
  end

  private

  attr_accessor :start, :players, :current_player, :areas

  def welcome
    clear_screen
    puts 'Dungeons & Dragons: The Lost Mine of Phandelver'
    puts '-----------------------------------------------'
    puts
  end

  def generate_areas
    areas_data = YAML.load_file('resources/areas.yml')

    areas_data.each do |area_id, desc|
      new_area = Area.new
      new_area.id = area_id
      new_area.description = desc
      add_location_data_to(new_area)
      areas[area_id] = new_area
    end
  end

  def add_location_data_to(area)
    locations_data = YAML.load_file('resources/locations.yml')

    locations_data.each do |loc_id, loc_details|
      if loc_details['area'] == area.id
        new_loc = Location.new
        new_loc.id = loc_id
        new_loc.area_id = area.id
        new_loc.description = loc_details['description']
        new_loc.display_name = loc_details['display_name']
        new_loc.paths = loc_details['paths'].split(' ')
        add_event_data_to(new_loc)
        area.locations[loc_id] = new_loc
      end
    end
  end

  def add_event_data_to(location)
    event_data = YAML.load_file('resources/events.yml')

    events = event_data.select do |ev_id, ev_details|
      ev_details['location'] == location.id
    end
    events.each do |ev_id, ev_details|
      location.events[ev_id] = ev_details
    end
  end

  def create_players
    loop do
      player = create_player
      players.add(player)
      break unless create_another_player?
      puts
    end
  end

  def create_player
    player = Player.new

    name = nil
    loop do
      puts "Add new player's name: "
      name = prompt
      break unless name =~ /\W/ || name.size < 3
      puts 'Sorry, that is not a valid name...'
    end
    player.name = name
    player
  end

  def create_another_player?
    input = nil

    loop do
      puts 'Would you like to add another player? (y/n) '
      input = prompt
      break if ['y', 'n'].include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    input == 'y' ? true : false
  end

  def set_players_in_starting_area_and_location
    players.each do |player|
      player.area = areas[start['area']]
      player.location = areas[start['area']].locations[start['location']]
    end
  end

  def set_current_player
    self.current_player = players.highest_initiative
  end

  def dm_describes_scene
    clear_screen
    puts 'Area Description:'
    puts '-----------------'
    puts current_player.area.description
    puts
    puts 'Current Player Turn:'
    puts '--------------------'
    puts current_player
    puts
    puts 'Current Location:'
    puts '---------------------'
    puts current_player.location.description
    puts
  end

  def dm_selects_player_turn
    self.current_player = players.select_player
  end

  def player_selects_action
    current_player.select_action
  end

  def resolve_player_turn
    EventHandler.new(current_player).run
    current_player.end_turn
    continue
  end
end

DND.new.run
