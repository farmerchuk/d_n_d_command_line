# main_menu_handler.rb

require_relative 'dnd'

class MainMenuHandler
  include Helpers::Data

  MENU_OPTIONS = ['choose player turn',
                  'view area map',
                  'view party equipment',
                  'view player profiles',
                  'travel to new area',
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
    display_area_narrative(starting_area)

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
    when 'travel to new area' then travel
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
    display_area_narrative(area) if area.narrative
    players.set_destination(area, locations)
  end

  def display_area_narrative(area)
    unless Game.completed_area_narratives.include?(area.id)
      display_narrative_header
      puts area.narrative
      Game.add_completed_area_narrative(area.id)
      Menu.prompt_continue
    end
  end

  def view_party_equipment
    players.current.backpack.view
    Menu.prompt_continue
  end

  def view_player_profiles
    display_summary(players)
    puts "Who's profile would you like to view?"
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

  def display_narrative_header
    Menu.clear_screen
    puts 'NARRATIVE INTERLUDE'
    Menu.draw_line
  end

  def display_summary(players)
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS'
    Menu.draw_line
    players.each do |player|
      if player.alive?
        puts "#{player.to_s.ljust(12)}" +
             "#{player.race} #{player.role} / #{player.current_hp} HP".ljust(28) +
             "is at the #{player.location.display_name}"
      else
        puts "#{player.to_s.ljust(12)}" + "DEAD".ljust(28) +
             "is at the #{player.location.display_name}".ljust(33)
      end
    end
    puts
    puts
    puts 'AREA DESCRIPTION'
    Menu.draw_line
    puts players.current.area.description
    puts
    puts
    puts 'MAIN MENU'
    Menu.draw_line
  end
end
