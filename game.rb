# game.rb

require_relative 'lib/helpers'
require_relative 'lib/player_list'
require_relative 'lib/player'
require_relative 'lib/area'
require_relative 'lib/location'
require_relative 'lib/event'
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
    @locations = []
    @events = []

    build_resources
  end

  def run
    welcome
    create_players
    stage_players
    set_current_player

    loop do
      dm_describes_scene
      dm_selects_player_turn
      dm_describes_scene
      player_turn
    end
  end

  private

  attr_accessor :players, :current_player, :areas, :locations, :events

  def build_resources
    build_areas
    build_locations
    build_events

    add_locations_to_areas
    add_area_to_locations
    add_paths_to_locations
    add_location_to_events
    add_encounter_to_events
  end

  def build_areas
    areas_data = YAML.load_file('resources/areas.yml')

    areas_data.each do |area|
      new_area = Area.new
      new_area.id = area['id']
      new_area.description = area['description']
      areas << new_area
    end
  end

  def build_locations
    locations_data = YAML.load_file('resources/locations.yml')

    locations_data.each do |location|
      new_loc = Location.new
      new_loc.id = location['id']
      new_loc.area_id = location['area_id']
      new_loc.path_ids = location['path_ids'].split
      new_loc.description = location['description']
      new_loc.display_name = location['display_name']
      locations << new_loc
    end
  end

  def build_events
    event_data = YAML.load_file('resources/events.yml')

    event_data.each do |event|
      new_event = Event.new
      new_event.id = event['id']
      new_event.location_id = event['location_id']
      new_event.description = event['description']
      new_event.trigger = event['trigger']
      events << new_event
    end
  end

  def add_locations_to_areas
    areas.each do |area|
      locations.each do |location|
        if location.area_id == area.id
          area.add_location(location)
        end
      end
    end
  end

  def add_area_to_locations
    locations.each do |location|
      areas.each do |area|
        if location.area_id == area.id
          location.area = area
        end
      end
    end
  end

  def add_paths_to_locations
    locations.each do |location1|
      locations.each do |location2|
        if location1.path_ids.include?(location2.id)
          location1.add_path(location2)
        end
      end
    end
  end

  def add_location_to_events
    events.each do |event|
      locations.each do |location|
        if event.location_id == location.id
          event.location = location
        end
      end
    end
  end

  def add_encounter_to_events
    # TBD
  end

  def welcome
    clear_screen
    puts 'Dungeons & Dragons: The Lost Mine of Phandelver'
    puts '-----------------------------------------------'
    puts
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

  def stage_players
    start = YAML.load_file('resources/initialize.yml')

    players.each do |player|
      areas.each do |area|
        if area.id == start['area_id']
         player.area = area
        end
      end
      locations.each do |location|
        if location.id == start['location_id']
          player.location = location
        end
      end
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
    players.each do |player|
      puts "#{player} is at: #{player.location.display_name}"
    end
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

  def player_turn
    player_choose_first_action

    if current_player.action == 'move'
      player_moves
      player_selects_action
      resolve_player_turn
    else
      player_selects_action
      resolve_player_turn
      player_moves
    end

    prompt_for_next_turn
  end

  def player_choose_first_action
    puts 'What action would the player like to take?'
    puts "0. move"
    puts "1. other action"

    choice = choose_num([0, 1])
    puts
    choice == 0 ? current_player.action = 'move' : nil
  end

  def player_moves
    current_player.action = 'move'
    EventHandler.new(current_player, events).run
    dm_describes_scene
  end

  def dm_selects_player_turn
    puts 'Which player would like to take a turn?'
    players.list_all_players
    choice = choose_num(0..players.size - 1)
    puts
    self.current_player = players[choice]
  end

  def player_selects_action
    puts 'What action would the player like to take?'
    Player::ACTIONS.each_with_index { |opt, idx| puts "#{idx}. #{opt}" }
    choice = choose_num(0..(Player::ACTIONS.size - 1))
    puts
    current_player.action = Player::ACTIONS[choice]
  end

  def resolve_player_turn
    EventHandler.new(current_player, events).run
    dm_describes_scene
  end
end

DND.new.run
