# general_battle_actions.rb

require_relative 'dnd'

module GeneralBattleActions
  def attack_successful?(target)
    conditions = target.conditions

    if condition_prevents_defence?(conditions)
      display_defender_conditions(conditions, target)
      return true
    else
      attack_roll = current_player.roll_attack
      display_attack_roll(attack_roll, target)
      attack_roll > target.armor_class
    end
  end

  def condition_prevents_defence?(conditions)
    conditions.include?('unconscious')
  end

  def display_defender_conditions(conditions, target)
    if conditions.include?('unconscious')
      puts "#{target} is unconscious and cannot defend."
      puts
    end
  end

  def resolve_damage(target)
    damage = current_player.roll_weapon_dmg
    target.current_hp -= damage
    damage
  end

  def clear_conditions_if_hurt(target, &block)
    starting_hp = target.current_hp
    block.call
    if target.current_hp < starting_hp
      target.clear_condition('unconscious')
    end
  end

  def display_attack_roll(attack_roll, target)
    puts "#{current_player} rolled #{attack_roll} to hit " +
         "versus an armor class of #{target.armor_class}..."
    puts
  end

  def display_summary
    Menu.clear_screen
    puts 'BATTLE TURN ORDER & PLAYER LOCATIONS'
    Menu.draw_line
    puts "NAME".ljust(14) +
         "RACE".ljust(12) +
         "ROLE".ljust(12) +
         "HP".rjust(4) + ' / '.ljust(3) +
         "MAX".ljust(8) +
         "CONDITIONS".ljust(14) +
         "LOCATION".ljust(24)
    puts
    all_entities.each do |entity|
      if entity.instance_of?(Player)
        entity_hps = entity.current_hp <= 0 ? 'DEAD' : entity.current_hp

        puts entity.name.ljust(14) +
             entity.race.to_s.ljust(12) +
             entity.role.to_s.capitalize.ljust(12) +
             entity_hps.to_s.rjust(4) + ' / '.ljust(3) +
             entity.max_hp.to_s.ljust(8) +
             entity.cond_acronym.join(' ').ljust(14) +
             entity.location.display_name.ljust(24) +
             (entity.current_turn ? '<< Current Player' : '')
      elsif entity.instance_of?(Enemy) && entity.alive?
        puts entity.name.ljust(14).colorize(:red) +
             entity.race.to_s.ljust(12).colorize(:red) +
             entity.role.to_s.capitalize.ljust(12).colorize(:red) +
             entity.current_hp.to_s.rjust(4).colorize(:red) +
             ' / '.ljust(3).colorize(:red) +
             entity.max_hp.to_s.ljust(8).colorize(:red) +
             entity.cond_acronym.join(' ').ljust(14).colorize(:red) +
             entity.location.display_name.ljust(24).colorize(:red) +
             (entity.current_turn ? '<< Current Player' : '')
      end
    end
    puts
    puts
    puts 'AREA MAP'
    Menu.draw_line
    puts players.first.area.map
    puts
    puts
    puts 'BATTLE DETAILS'
    Menu.draw_line
  end
end
