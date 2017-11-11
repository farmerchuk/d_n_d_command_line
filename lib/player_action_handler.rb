# player_action_handler.rb

require_relative 'dnd'

module PlayerActionHandler
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

  def execute_player_action
    case current_player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
    when 'attack' then player_attack
    when 'magic' then player_magic
    end
  end

  def player_choose_first_action
    puts "What action would #{current_player.name} like to take first?"
    choice = Menu.choose_from_menu(['move', 'other action'])
    choice == 'move' ? current_player.action = 'move' : nil
  end

  def player_also_move?
    puts "Would #{current_player.name} also like to move?"
    choice = Menu.choose_from_menu(['yes', 'no'])
    choice == 'yes' ? true : false
  end

  def player_move
    puts "Where would #{current_player.name} like to move to?"
    available_locations = current_player.location.paths
    current_player.location = Menu.choose_from_menu(available_locations)

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

  def player_magic
    puts "What spell would #{current_player.name} like to use?"
  end

  def action_possible?(current_context)
    if current_player.action == 'magic'
      return false unless current_player.spells.any? do |spell|
        spell.when == current_context
      end
    end

    if current_player.action == 'attack'
      return false if targets_in_range(enemies).empty?
    end

    true
  end

  def display_action_error
    case current_player.action
    when 'magic'
      puts 'None of your spells would be effective right now.'
    when 'attack'
      puts "No enemies are within range. Try moving closer first or"
      puts "equipping a weapon with greater range."
    end

    puts
    puts 'Please select another option...'
    puts
  end

  def player_equip
    available_equipment = current_player.backpack.all_unequipped_equipment

    if available_equipment.empty?
      puts 'Sorry, all equipment is currently in use...'
    else
      current_player.backpack.view_equippable

      puts "Select the item to equip:"
      choice = Menu.choose_from_menu(available_equipment)

      if choice.instance_of?(Weapon)
        current_player.unequip(current_player.equipped_weapon)
      elsif choice.instance_of?(Armor) && choice.type == 'shield'
        current_player.unequip(current_player.equipped_shield)
      elsif choice.instance_of?(Armor)
        current_player.unequip(current_player.equipped_armor)
      end

      current_player.equip(choice.id)
    end
  end
end
