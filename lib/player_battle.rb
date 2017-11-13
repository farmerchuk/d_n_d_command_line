# player_battle.rb

require_relative 'dnd'

class PlayerBattle < PlayerActionHandler
  include GeneralBattleActions

  attr_reader :action_type, :enemies, :all_entities

  def initialize(players, locations, enemies, all_entities)
    super(players, locations)
    @enemies = enemies
    @all_entities = all_entities
    @action_type = 'battle'
  end

  def player_attack
    targets = targets_in_range(enemies)

    if targets.empty?
      display_ineffective_action do
        puts "No enemies are within range. Try moving closer first or"
        puts "equipping a weapon with greater range."
        puts
        puts 'Please select another option...'
      end
      action_fail
    else
      target_enemy = select_enemy_to_attack(targets)
      hit = attack_successful?(target_enemy)
      damage = resolve_damage(target_enemy) if hit
      display_attack_summary(hit, damage, target_enemy)
    end
  end

  def select_enemy_to_attack(targets)
    puts "Which enemy would #{current_player.name} like to attack?"
    choose_target_menu_with_location(targets)
  end

  def display_attack_summary(hit, damage, target)
    if hit
      puts "#{current_player}'s attack was successful!"
      puts
      puts "You hit the #{target} with a " +
           "#{current_player.equipped_weapon.display_name} " +
           "and dealt #{damage} damage."
    else
      puts "#{current_player} attacks #{target} with a " +
           "#{current_player.equipped_weapon.display_name} and missed!"
    end
  end
end
