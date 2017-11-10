# enemy_battle_action_handler.rb

require_relative 'dnd'

class EnemyBattleActionHandler < BattleActionHandler
  attr_accessor :current_player

  def initialize(players, locations, enemies, all_entities, enemy)
    super(players, locations, enemies, all_entities)
    @current_player = enemy
  end

  def run
    display_battle_summary
    targets = targets_in_range(players.to_a)

    if targets.empty?
      # move closer
      # attack if possible
    else
      attack(targets)
    end
    display_battle_summary
    Menu.prompt_for_next_turn
  end

  def attack(targets)
    target_player = targets.sample
    hit = attack_successful?(target_player)
    damage = resolve_damage(target_player) if hit
    display_attack_summary(hit, damage, target_player)
    Menu.prompt_continue
  end

  def display_attack_summary(hit, damage, target)
    if hit
      puts "#{current_player}'s attack was successful!"
      puts
      puts "The #{current_player} hit #{target} with a " +
           "#{current_player.equipped_weapon.display_name} " +
           "and dealt #{damage} damage."
    else
      puts "#{current_player}'s attack on #{target} missed!"
    end
  end
end
