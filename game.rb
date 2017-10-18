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
    @players = PlayerList.new
    @current_player = nil
    @areas = []
  end

  def run
    welcome
    generate_areas
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

  attr_accessor :players, :current_player, :areas

  def welcome
    clear_screen
    puts 'Dungeons & Dragons: The Lost Mine of Phandelver'
    puts '-----------------------------------------------'
    puts
  end

  def generate_areas
    areas_data = YAML.load_file('resources/areas.yml')

    areas_data.each do |area|
      new_area = Area.new
      new_area.id = area['id']
      new_area.description = area['description']
      add_location_data_to(new_area)
      areas << new_area
    end
  end

  def add_location_data_to(area)
    locations_data = YAML.load_file('resources/locations.yml')

    locations_data.each do |location|
      if location['area_id'] == area.id
        new_loc = Location.new
        new_loc.id = location['id']
        new_loc.area_id = area.id
        new_loc.description = location['description']
        new_loc.display_name = location['display_name']
        new_loc.paths = location['paths'].split(' ')
        add_event_data_to(new_loc)
        area << new_loc
      end
    end
  end

  def add_event_data_to(location)
    event_data = YAML.load_file('resources/events.yml')

    events = event_data.select do |event|
      event['location_id'] == location.id
    end
    events.each do |event|
      location.events << event
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
    start = YAML.load_file('resources/initialize.yml')

    players.each do |player|
      player.area = areas.select do |area|
        area.id == start['area']
      end.first
      player.location = player.area.locations.select do |location|
        location.id == start['location']
      end.first
    end
  end

  def set_current_player
    self.current_player = players.highest_initiative
  end

  def dm_describes_scene
    clear_screen
    puts 'Area Description:'
    puts '------------------------------------'
    puts current_player.area.description
    puts
    puts 'Player Locations'
    puts '------------------------------------'
    players.each { |player| puts "#{player} is at: #{player.location}" }
    puts
    puts 'Current Player Turn:'
    puts '------------------------------------'
    puts current_player
    puts
    puts 'Current Player Location Description:'
    puts '------------------------------------'
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
    next_turn
  end
end

DND.new.run
