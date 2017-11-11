# explore_action_handler.rb

require_relative 'dnd'

class ExploreActionHandler
  include PlayerActionHandler

  attr_accessor :players, :current_player, :locations, :events, :event, :script

  def initialize(players, locations, events)
    @players = players
    @current_player = players.current
    @locations = locations
    @events = events
    @event = nil
    @script = nil
  end

  def run_action
    display_summary
    set_event
    set_script
    resolve_player_action
    reset_event
    current_player.end_action
    Menu.prompt_continue
    display_summary
  end

  def player_selects_action
    loop do
      puts "What action would #{current_player.name} like to take?"
      role = current_player.role.to_s

      case role
      when 'fighter'
        current_player.action = Menu.choose_from_menu(Fighter::EXPLORE_ACTIONS)
      when 'rogue'
        current_player.action = Menu.choose_from_menu(Rogue::EXPLORE_ACTIONS)
      when 'cleric'
        current_player.action = Menu.choose_from_menu(Cleric::EXPLORE_ACTIONS)
      when 'wizard'
        current_player.action = Menu.choose_from_menu(Wizard::EXPLORE_ACTIONS)
      end

      break if action_possible?('explore')
      display_summary
      display_action_error
    end
  end

  def resolve_player_action
    execute_player_action
    execute_event_description
    execute_event_script
  end

  def set_event
    return unless events
    events.each do |evt|
      if evt.trigger == current_player.action &&
         evt.location == current_player.location
        self.event = evt
      end
    end
  end

  def set_script
    self.script = event && event.script ? event.script : nil
  end

  def execute_event_description
    if event
      puts event.description
    else
      puts 'Nothing happens...' unless current_player.action == 'equip'
    end
  end

  def execute_event_script
    eval(script) if script
  end

  def reset_event
    self.event = nil
    self.script = nil
  end

  def display_summary
    self.class.display_summary(players)
  end

  def self.display_summary(players)
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS:'
    Menu.draw_line
    players.each do |player|
      puts "#{player.to_s.ljust(12)}" +
           "(#{player.race} #{player.role} / #{player.current_hp} HP)".ljust(28) +
           "is at the #{player.location.display_name}".ljust(33) +
           (player.current_turn ? "<< Current Player" : "")
    end
    puts
    puts
    puts "CURRENT PLAYER LOCATION: #{players.current.location.display_name}"
    Menu.draw_line
    puts players.current.location.description
    puts
    puts
    puts 'EXPLORATION DETAILS:'
    Menu.draw_line
  end
end
