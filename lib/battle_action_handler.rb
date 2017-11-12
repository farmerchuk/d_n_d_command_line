# battle_action_handler.rb

require_relative 'dnd'

class BattleActionHandler
  attr_accessor :players, :locations, :enemies, :all_entities

  def initialize(players, locations, enemies, all_entities)
    @players = players
    @locations = locations
    @enemies = enemies
    @all_entities = all_entities
  end

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
    self.class.display_summary(all_entities, players)
  end

  def self.display_summary(all_entities, players)
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
