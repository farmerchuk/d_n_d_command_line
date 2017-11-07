# action_handler.rb

require_relative 'helpers'
require_relative 'encounter_handler'

class ActionHandler
  include Helpers::Format
  include Helpers::Menus
  include Helpers::Prompts
  include Helpers::Messages
  include Helpers::Displays

  attr_accessor :players, :player, :current_player, :enemies, :locations,
                :events, :event, :script, :actions

  def initialize(players, current_player, enemies, locations, events, actions)
    @players = players
    @current_player = current_player
    @enemies = enemies
    @locations = locations
    @events = events
    @event = nil
    @script = nil
    @actions = actions
  end

  def run
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
    prompt_for_next_turn
  end

  def run_action
    display_player_summary(players, current_player)
    set_event
    set_script
    resolve_player_action
    reset_event
    prompt_continue
    display_player_summary(players, current_player)
  end

  def player_choose_first_action
    puts "What action would #{current_player.name} like to take first?"
    choice = choose_from_menu(['move', 'other action'])
    choice == 'move' ? current_player.action = 'move' : nil
  end

  def player_also_move?
    puts "Would #{current_player.name} also like to move?"
    choice = choose_from_menu(['yes', 'no'])
    choice == 'yes' ? true : false
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

  def reset_event
    current_player.end_action
    self.event = nil
    self.script = nil
  end

  def player_selects_action
    puts "What action would #{current_player.name} like to take?"
    current_player.action = choose_from_menu(actions)
  end

  def resolve_player_action
    execute_player_action
    execute_event_description
    execute_event_script
  end

  def execute_player_action
    case current_player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
    when 'attack' then player_attack
    end
  end

  def execute_event_description
    if event
      puts event.description
    else
      puts no_event_msg unless current_player.action == 'equip'
    end
  end

  def execute_event_script
    eval(script) if script
  end

  def player_move
    puts "Where would #{current_player.name} like to move to?"
    available_locations = current_player.location.paths
    current_player.location = choose_from_menu(available_locations)

    puts "#{current_player} is now at the #{current_player.location.display_name}"
    puts
  end

  def player_wait
    puts "#{current_player} is on alert!"
    puts
  end

  def player_use_skill
    puts "#{current_player} uses a skill."
    puts
  end

  def player_use_item
    puts "#{current_player} uses an item."
    puts
  end

  def player_rest
    puts "#{current_player} rests."
    puts
  end

  def player_equip
    available_equipment = current_player.backpack.all_unequipped_equipment

    if available_equipment.empty?
      no_equippable_msg
    else
      current_player.backpack.view_equippable

      puts "Select the item to equip:"
      choice = choose_from_menu(available_equipment)

      if choice.instance_of?(Weapon)
        current_player.unequip(current_player.equipped_weapon)
      elsif choice.instance_of?(Armor)
        current_player.unequip(current_player.equipped_armor)
      elsif choice.instance_of?(Shield)
        current_player.unequip(current_player.equipped_shield)
      end

      current_player.equip(choice.id)
    end
  end

  def player_attack

  end
end
