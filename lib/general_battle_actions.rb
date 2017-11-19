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

  def remove_unconscious(target)
    target.clear_condition('unconscious')
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
    all_entities.each do |entity|
      if entity.alive?
        if entity.instance_of?(Player)
          puts "#{entity.to_s.ljust(12)}" +
               "#{entity.race} #{entity.role} / #{entity.current_hp} HP".ljust(28) +
               "is at the #{entity.location.display_name}".ljust(33) +
               (entity.current_turn ? "<< Current Player" : "")
        elsif entity.instance_of?(Enemy)
          puts "#{entity.to_s.ljust(12)}" +
               "Monster / #{entity.current_hp} HP".ljust(28) +
               "is at the #{entity.location.display_name}".ljust(33) +
               (entity.current_turn ? "<< Current Player" : "")
        end
      else
        puts "#{entity.to_s.ljust(12)}" + "DEAD".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33)
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
