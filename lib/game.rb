# game.rb

require_relative 'dnd'

class Game
  include Helpers::Data

  MENU_OPTIONS = ['area description',
                  'view party equipment',
                  'view player profiles',
                  'choose player turn',
                  'save and quit']

  def initialize
    @players = PlayerList.new
    @areas = []
    @locations = []
    @events = []

    build_resources
  end

  def run
    welcome
    create_players
    initialize_player_equipment
    stage_players
    set_current_player

    loop do
      ExploreActionHandler.display_summary(players)
      dm_selects_from_main_menu
    end
  end

  private

  attr_accessor :players, :areas, :locations, :events

  def build_resources
    build_areas
    build_locations
    build_events

    add_locations_to_areas
    add_area_to_locations
    add_paths_to_locations
    add_location_to_events
  end

  def build_areas
    areas_data = YAML.load_file('../assets/yaml/areas.yml')

    areas_data.each do |area|
      new_area = Area.new
      new_area.id = area['id']
      new_area.description = area['description']
      new_area.map = area['map']
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

  def welcome
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')

    Menu.clear_screen
    puts
    puts initialize_data['title']
    Menu.draw_line
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
      name = Menu.prompt
      break unless name =~ /\W/ || name.size < 3
      puts 'Sorry, that is not a valid name...'
    end

    player.name = name
  end

  def add_role(player)
    puts "What role will #{player.name} be?"
    role = Menu.choose_from_menu(PlayerRole::ROLES)

    case role
    when 'fighter' then player.role = Fighter.new
    when 'rogue' then player.role = Rogue.new
    when 'cleric' then player.role = Cleric.new
    when 'wizard' then player.role = Wizard.new
    end
  end

  def add_race(player)
    puts "What race will #{player.name} be?"
    role = Menu.choose_from_menu(PlayerRace::RACES)

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
      input = Menu.prompt
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
      shield_id = role_equipment['shield']
      backpack.add(Equipment.build_weapon(weapon_id)) if weapon_id
      backpack.add(Equipment.build_armor(armor_id)) if armor_id
      backpack.add(Equipment.build_armor(shield_id)) if shield_id
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
      weapon_id = role_equipment['weapon']
      armor_id = role_equipment['armor']
      shield_id = role_equipment['shield']
      player.equip(weapon_id) if weapon_id
      player.equip(armor_id) if armor_id
      player.equip(shield_id) if shield_id
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
    current_player = players.highest_initiative
    current_player.set_current_turn!
  end

  def dm_selects_from_main_menu
    puts 'Select an option:'
    choice = Menu.choose_from_menu(MENU_OPTIONS)

    case choice
    when 'area description' then dm_chose_area_description
    when 'view party equipment' then dm_chose_view_party_equipment
    when 'view player profiles' then dm_chose_view_player_profiles
    when 'choose player turn' then dm_chose_player_turn
    when 'save and quit' then dm_chose_save_and_quit
    end
  end

  def dm_chose_area_description
    ExploreActionHandler.display_summary(players)
    puts players.current.area.description
    puts
    puts players.current.area.map
    puts
    Menu.prompt_continue
  end

  def dm_chose_view_party_equipment
    players.current.backpack.view
    Menu.prompt_continue
  end

  def dm_chose_view_player_profiles
    puts 'Which player?'
    player = Menu.choose_from_menu(players.to_a)

    player.view
    Menu.prompt_continue
  end

  def dm_chose_player_turn
    dm_selects_player_turn
    player_turn
  end

  def dm_chose_save_and_quit
    exit
  end

  def dm_selects_player_turn
    players.current.unset_current_turn!
    puts 'Which player would like to take a turn?'
    current_player = Menu.choose_from_menu(players.to_a)
    current_player.set_current_turn!
  end

  def player_turn
    ExploreActionHandler.new(
      players,
      locations,
      events).run
  end
end

Game.new.run
