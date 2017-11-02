# game.rb

require_relative 'helpers'
require_relative 'main_menu'
require_relative 'player_list'
require_relative 'player'
require_relative 'player_role'
require_relative 'player_race'
require_relative 'backpack'
require_relative 'coin_purse'
require_relative 'equipment'
require_relative 'area'
require_relative 'location'
require_relative 'event'
require_relative 'event_handler'

require 'yaml'
require 'pry'

# Game logic

class DND
  include Helpers::Format
  include Helpers::Menus
  include Helpers::Prompts
  include Helpers::Data

  def initialize
    @players = PlayerList.new
    @current_player = nil
    @areas = []
    @locations = []
    @events = []
    @armors = []
    @weapons = []
    @gears = []
    @tools = []

    build_resources
  end

  def run
    welcome
    create_players
    initialize_player_equipment
    stage_players
    set_current_player

    loop do
      dm_describes_scene
      dm_selects_from_main_menu
    end
  end

  private

  attr_accessor :players, :current_player, :areas, :locations, :events,
                :armors, :weapons, :gears, :tools

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
    areas_data = YAML.load_file('../assets/yaml/areas.yml')

    areas_data.each do |area|
      new_area = Area.new
      new_area.id = area['id']
      new_area.description = area['description']
      areas << new_area
    end
  end

  def build_locations
    locations_data = YAML.load_file('../assets/yaml/locations.yml')

    locations_data.each do |location|
      new_loc = Location.new
      new_loc.id = location['id']
      new_loc.area_id = location['area_id']
      new_loc.path_ids = location['path_ids']
      new_loc.description = location['description']
      new_loc.display_name = location['display_name']
      locations << new_loc
    end
  end

  def build_events
    event_data = YAML.load_file('../assets/yaml/events.yml')

    event_data.each do |event|
      new_event = Event.new
      new_event.id = event['id']
      new_event.location_id = event['location_id']
      new_event.description = event['description']
      new_event.trigger = event['trigger']
      new_event.script = event['script']
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
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')

    clear_screen
    puts initialize_data['title']
    puts '-----------------------------------------------------------------'
    puts
  end

  def create_players
    loop do
      player = create_player
      players.add(player)
      break unless create_another_player?
    end
  end

  def create_player
    player = Player.new

    add_name(player)
    add_role(player)
    add_race(player)
    player.set_current_hp_to_max

    player
  end

  def add_name(player)
    name = nil

    loop do
      puts "Add new player's name: "
      name = prompt
      break unless name =~ /\W/ || name.size < 3
      puts 'Sorry, that is not a valid name...'
    end

    player.name = name
  end

  def add_role(player)
    puts "What role will #{player.name} be?"
    role = choose_from_menu(PlayerRole::ROLES)

    case role
    when 'fighter' then player.role = Fighter.new
    when 'rogue' then player.role = Rogue.new
    when 'cleric' then player.role = Cleric.new
    when 'wizard' then player.role = Wizard.new
    end
  end

  def add_race(player)
    puts "What race will #{player.name} be?"
    role = choose_from_menu(PlayerRace::RACES)

    case role
    when 'human' then player.race = Human.new
    when 'dwarf' then player.race = Dwarf.new
    when 'elf' then player.race = Elf.new
    when 'half-elf' then player.race = HalfElf.new
    when 'halfling' then player.race = Halfling.new
    when 'gnome' then player.race = Gnome.new
    end
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

  def initialize_player_equipment
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')

    purse = CoinPurse.new(initialize_data['party_gold'])
    backpack = Backpack.new
    backpack.purse = purse

    add_starting_equipment_to_backpack(backpack, initialize_data)
    add_equipment_to_players(backpack)
    equip_players(backpack)
  end

  def add_starting_equipment_to_backpack(backpack, initialize_data)
    players.each do |player|
      role = player.role.to_s.downcase
      role_equipment = initialize_data['party_equipment'][role]
      weapon_id = role_equipment['weapon']
      armor_id = role_equipment['armor']
      backpack.add(Equipment.build_weapon(weapon_id))
      backpack.add(Equipment.build_armor(armor_id))
    end
  end

  def add_equipment_to_players(backpack)
    players.each do |player|
      player.backpack = backpack
    end
  end

  def equip_players(backpack)
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')

    players.each do |player|
      role = player.role.to_s.downcase
      role_equipment = initialize_data['party_equipment'][role]
      weapon = role_equipment['weapon']
      armor = role_equipment['armor']
      player.equip(weapon)
      player.equip(armor)
    end
  end

  def stage_players
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')

    players.each do |player|
      areas.each do |area|
        if area.id == initialize_data['area_id']
         player.area = area
        end
      end
      locations.each do |location|
        if location.id == initialize_data['location_id']
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
    puts '-----------------------------------------------------------------'
    puts current_player.area.description
    puts
    puts 'Player Locations:'
    puts '-----------------------------------------------------------------'
    players.each do |player|
      puts "#{player} is at: #{player.location.display_name}"
    end
    puts
    puts 'Current Player Turn:'
    puts '-----------------------------------------------------------------'
    puts "#{current_player} (#{current_player.race} #{current_player.role})"
    puts
    puts 'Current Player Location Description:'
    puts '-----------------------------------------------------------------'
    puts current_player.location.description
    puts
  end

  def player_turn
    current_player.start_turn
    player_choose_first_action

    if current_player.action == 'move'
      player_moves
      player_selects_action
      resolve_player_turn
    else
      player_selects_action
      resolve_player_turn
      player_moves if player_also_move?
    end

    prompt_for_next_turn
  end

  def player_choose_first_action
    puts "What action would #{current_player.name} like to take first?"
    choice = choose_from_menu(['move', 'other action'])
    choice == 'move' ? current_player.action = 'move' : nil
  end

  def player_moves
    current_player.action = 'move'
    resolve_player_turn
  end

  def player_also_move?
    puts "Would #{current_player.name} also like to move?"
    choice = choose_from_menu(['yes', 'no'])
    choice == 'yes' ? true : false
  end

  def dm_selects_from_main_menu
    puts 'Select an option:'
    choice = choose_from_menu(MainMenu::OPTIONS)

    case choice
    when 'view party equipment' then dm_chose_view_party_equipment
    when 'view player profiles' then dm_chose_view_player_profiles
    when 'choose player turn' then dm_chose_player_turn
    end
  end

  def dm_chose_view_party_equipment
    current_player.backpack.view
    prompt_continue
  end

  def dm_chose_view_player_profiles
    puts 'Which player?'
    player = choose_from_menu(players.to_a)

    player.view
    prompt_continue
  end

  def dm_chose_player_turn
    dm_selects_player_turn
    dm_describes_scene
    player_turn
  end

  def dm_selects_player_turn
    puts 'Which player would like to take a turn?'
    self.current_player = choose_from_menu(players.to_a)
  end

  def player_selects_action
    puts "What action would #{current_player.name} like to take?"
    current_player.action = choose_from_menu(Player::ACTIONS)
  end

  def resolve_player_turn
    EventHandler.new(current_player, events).run
    dm_describes_scene
  end
end

DND.new.run
