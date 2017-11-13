# general_battle_actions.rb

require_relative 'dnd'

module GeneralBattleActions
  def attack_successful?(target)
    attack_roll = current_player.roll_attack
    puts "#{current_player} rolled #{attack_roll} to hit " +
         "versus an armor class of #{target.armor_class}..."
    puts
    attack_roll > target.armor_class
  end

  def resolve_damage(target)
    damage = current_player.roll_weapon_dmg
    target.current_hp -= damage
    damage
  end

  def display_summary
    Menu.clear_screen
    puts 'BATTLE TURN ORDER & PLAYER LOCATIONS'
    Menu.draw_line
    all_entities.each do |entity|
      if entity.instance_of?(Player)
        puts "#{entity.to_s.ljust(12)}" +
             "(#{entity.race} #{entity.role} / #{entity.current_hp} HP)".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33) +
             (entity.current_turn ? "<< Current Player" : "")
      elsif entity.instance_of?(Enemy)
        puts "#{entity.to_s.ljust(12)}" +
             "(Monster / #{entity.current_hp} HP)".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33) +
             (entity.current_turn ? "<< Current Player" : "")
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
