# event_handler.rb

require_relative 'helpers'
require_relative 'encounter_handler'

class EventHandler
  include Helpers::Format
  include Helpers::Menus
  include Helpers::Prompts
  include Helpers::Messages
  include Helpers::Displays

  attr_accessor :players, :player, :locations,
                :events, :event, :script, :actions

  def initialize(players, current_player, locations, events, actions)
    @players = players
    @player = current_player
    @locations = locations
    @events = events
    @event = nil
    @script = nil
    @actions = actions
  end

  def run
    player.start_turn
    player_choose_first_action

    if player.action == 'move'
      run_action
      player_selects_action
      run_action
    else
      player_selects_action
      run_action
      player.action = 'move' if player_also_move?
      run_action
    end
    prompt_for_next_turn
  end

  def run_action
    dm_describes_scene(players, player)
    set_event
    set_script
    resolve_player_action
    reset_event
    prompt_continue
    dm_describes_scene(players, player)
  end

  def player_choose_first_action
    puts "What action would #{player.name} like to take first?"
    choice = choose_from_menu(['move', 'other action'])
    choice == 'move' ? player.action = 'move' : nil
  end

  def player_also_move?
    puts "Would #{player.name} also like to move?"
    choice = choose_from_menu(['yes', 'no'])
    choice == 'yes' ? true : false
  end

  def set_event
    events.each do |evt|
      if evt.trigger == player.action && evt.location == player.location
        self.event = evt
      end
    end
  end

  def set_script
    self.script = event && event.script ? event.script : nil
  end

  def reset_event
    player.end_action
    self.event = nil
    self.script = nil
  end

  def player_selects_action
    puts "What action would #{player.name} like to take?"
    player.action = choose_from_menu(actions)
  end

  def resolve_player_action
    execute_player_action
    execute_event_description
    execute_event_script
  end

  def execute_player_action
    case player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
    end
  end

  def execute_event_description
    if event
      puts event.description
    else
      puts no_event_msg unless player.action == 'equip'
    end
  end

  def execute_event_script
    eval(script) if script
  end

  def player_move
    puts "Where would #{player.name} like to move to?"
    available_locations = player.location.paths
    player.location = choose_from_menu(available_locations)

    puts "#{player} is now at the #{player.location.display_name}"
    puts
  end

  def player_wait
    puts "#{player} is on alert!"
    puts
  end

  def player_use_skill
    puts "#{player} uses a skill."
    puts
  end

  def player_use_item
    puts "#{player} uses an item."
    puts
  end

  def player_rest
    puts "#{player} rests."
    puts
  end

  def player_equip
    available_equipment = player.backpack.all_unequipped_equipment

    if available_equipment.empty?
      no_equippable_msg
    else
      player.backpack.view_equippable

      puts "Select the item to equip:"
      choice = choose_from_menu(available_equipment)

      if choice.instance_of?(Weapon)
        player.unequip(player.equipped_weapon)
      elsif choice.instance_of?(Armor)
        player.unequip(player.equipped_armor)
      elsif choice.instance_of?(Shield)
        player.unequip(player.equipped_shield)
      end

      player.equip(choice.id)
    end
  end
end
