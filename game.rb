# game.rb

require_relative 'lib/helpers'
require_relative 'lib/player_list'
require_relative 'lib/player'
require_relative 'lib/area'
require_relative 'lib/location'

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
    create_players
    set_players_in_starting_area_and_location
    set_current_player
    dm_describes_scene

    loop do
      dm_selects_player_turn
      dm_describes_scene
      player_selects_action
      # event_handler
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
    locations_data = YAML.load_file('resources/locations.yml')
    event_data = YAML.load_file('resources/events.yml')

    areas_data.each do |area_id, desc|
      new_area = Area.new
      new_area.id = area_id
      new_area.description = desc

      locations_data.each do |loc_id, loc_details|
        if loc_details['area'] == area_id
          new_loc = Location.new
          new_loc.id = loc_id
          new_loc.area_id = area_id
          new_loc.description = loc_details['description']
          new_loc.paths = loc_details['paths'].split(' ')

          events = event_data.select do |ev_id, ev_details|
            ev_details['location'] == loc_id
          end
          events.each do |ev_id, ev_details|
            new_loc.events[ev_id] = ev_details
          end

          new_area.locations[loc_id] = new_loc
        end
      end
      areas[area_id] = new_area
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
    puts 'Location Description:'
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

  def event_handler
    Event.new.run
    current_player.end_turn
  end
end

DND.new.run
