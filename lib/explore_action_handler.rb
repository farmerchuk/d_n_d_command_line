# explore_action_handler.rb

require_relative 'dnd'

class ExploreActionHandler < ActionHandler
  ACTIONS = %w[move examine search wait skill item equip rest engage]

  attr_accessor :events, :event, :script

  def initialize(players, locations, events)
    super(players, locations)
    @events = events
    @event = nil
    @script = nil
  end

  def run
    display_summary
    current_player.start_turn
    player_choose_first_action

    if current_player.action == 'move'
      run_action
      player_selects_action
      run_action
    else
      player_selects_action
      run_action
      current_player.action = 'move' if player_also_move?
      run_action
    end
    Menu.prompt_for_next_turn
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
    puts "What action would #{current_player.name} like to take?"
    current_player.action = Menu.choose_from_menu(ACTIONS)
  end

  def execute_player_action
    case current_player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
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
