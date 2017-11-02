# event_handler.rb

require_relative 'helpers'

class EventHandler
  include Helpers::Format
  include Helpers::Menus
  include Helpers::Prompts
  include Helpers::Messages

  attr_accessor :player, :events, :event, :script

  def initialize(current_player, events)
    @player = current_player
    @events = events
    @event = set_event
    @script = set_script
  end

  def run
    resolve_player_action
    prompt_continue
    player.end_action
  end

  def set_event
    events.each do |event|
      if event.trigger == player.action && event.location == player.location
        return event
      end
    end
    nil
  end

  def set_script
    return nil unless event
    event.script ? event.script : nil
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
