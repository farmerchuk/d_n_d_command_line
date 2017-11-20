# main_menu_handler.rb

require_relative 'dnd'

class MainMenuHandler
  include Helpers::Data

  MENU_OPTIONS = ['choose player turn',
                  'party rest',
                  'view area map',
                  'view party equipment',
                  'view player profiles',
                  'fast travel',
                  'save and quit']

  attr_reader :players, :areas, :locations

  def initialize(players, areas, locations)
    @players = players
    @areas = areas
    @locations = locations
  end

  def run
    initialize_data = YAML.load_file('../assets/yaml/initialize.yml')
    starting_area = retrieve(initialize_data['area_id'], areas)
    display_area_introduction(starting_area)
    Menu.prompt_continue

    loop do
      display_summary(players)
      select_from_main_menu
    end
  end

  private

  def select_from_main_menu
    puts 'Select an option:'
    choice = Menu.choose_from_menu(MENU_OPTIONS)

    case choice
    when 'view area map' then view_map
    when 'fast travel' then travel
    when 'party rest' then party_rest
    when 'view party equipment' then view_party_equipment
    when 'view player profiles' then view_player_profiles
    when 'choose player turn' then player_turn
    when 'save and quit' then save_and_quit
    end
  end

  def view_map
    players.current.area.display_map
    Menu.prompt_continue
  end

  def travel
    display_summary(players)
    puts "Where would the party like to travel to?"
    other_areas = areas.select do |area|
      area.id != players.first.area.id && area.unlocked?
    end
    area = Menu.choose_from_menu(other_areas)
    display_area_introduction(area)
    players.set_new_area(area, locations)
  end

  def display_area_introduction(area)
    self.class.display_area_introduction(area)
  end

  def self.display_area_introduction(area)
    if area.introduction && !Game.completed_area_introductions.include?(area.id)
      MainMenuHandler.display_introduction_header
      puts area.introduction
      Game.add_completed_area_introduction(area.id)
    end
  end

  def party_rest
    display_summary(players)
    players.rest
    Menu.prompt_continue
  end

  def view_party_equipment
    players.current.backpack.view
    Menu.prompt_continue
  end

  def view_player_profiles
    display_summary(players)
    puts "Whose profile would you like to view?"
    player = Menu.choose_from_menu(players.to_a)

    player.view
    Menu.prompt_continue
  end

  def player_turn
    select_player_turn
    start_player_turn
  end

  def save_and_quit
    exit
  end

  def select_player_turn
    display_summary(players)
    players.current.unset_current_turn!
    puts 'Which player would like to take a turn?'
    current_player = Menu.choose_from_menu(players.to_a)
    current_player.set_current_turn!
  end

  def start_player_turn
    PlayerExplore.new(players, locations, areas).run
  end

  def self.display_introduction_header
    Menu.clear_screen
    puts 'AREA INTRODUCTION'
    Menu.draw_line
  end

  def display_summary(players)
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS'
    Menu.draw_line
    puts "NAME".ljust(14) +
         "RACE".ljust(12) +
         "ROLE".ljust(12) +
         "HP".rjust(4) + ' / '.ljust(3) +
         "MAX".ljust(8) +
         "CONDITIONS".ljust(14) +
         "LOCATION".ljust(24)
    puts
    players.each do |player|
      puts player.name.ljust(14) +
           player.race.to_s.ljust(12) +
           player.role.to_s.capitalize.ljust(12) +
           player.current_hp.to_s.rjust(4) + ' / '.ljust(3) +
           player.max_hp.to_s.ljust(8) +
           player.cond_acronym.join(' ').ljust(14) +
           player.location.display_name.ljust(24)
    end
    puts
    puts
    puts "AREA DESCRIPTION: #{players.current.area}"
    Menu.draw_line
    puts players.current.area.description
    puts
    puts
    puts 'MAIN MENU'
    Menu.draw_line
  end
end
