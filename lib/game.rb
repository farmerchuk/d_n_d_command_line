# game.rb

require_relative 'dnd'

class Game
  include Helpers::Data

  def initialize
    @players = PlayerList.new
    @areas = []
    @locations = []

    build_resources
  end

  def run
    create_players
    initialize_player_equipment
    stage_players
    set_current_player

    MainMenuHandler.new(players, locations).run
  end

  private

  attr_accessor :players, :areas, :locations

  def build_resources
    build_areas
    build_locations

    add_locations_to_areas
    add_area_to_locations
    add_paths_to_locations
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
      welcome
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
    add_spells(player)
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
    race = Menu.choose_from_menu(PlayerRace::RACES)

    case race
    when 'human' then player.race = Human.new
    when 'dwarf' then player.race = Dwarf.new
    when 'elf' then player.race = Elf.new
    when 'half-elf' then player.race = HalfElf.new
    when 'halfling' then player.race = Halfling.new
    when 'gnome' then player.race = Gnome.new
    end
  end

  def add_spells(player)
    role = player.role.to_s
    player.spells = Spell.generate_spells(role)
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
      role = player.role.to_s
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
      role = player.role.to_s
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
end

Game.new.run
