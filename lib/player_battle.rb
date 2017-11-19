# player_battle.rb

require_relative 'dnd'

class PlayerBattle < PlayerActionHandler
  include GeneralBattleActions

  attr_reader :action_type, :enemies, :all_entities

  def initialize(players, locations, enemies, all_entities)
    super(players, locations, areas)
    @enemies = enemies
    @all_entities = all_entities
    @action_type = 'battle'
  end

  def player_move
    puts "Where would #{current_player.name} like to move to?"
    available_locations =
      current_player.available_paths_during_battle
    current_player.location = Menu.choose_from_menu(available_locations)
  end

  def run_actions
    2.times do |n|
      next if enemies.all? { |enemy| enemy.dead? }
      display_summary
      cycle_action(n)
      Menu.prompt_continue
    end
  end

  def player_attack
    targets = targets_in_range(enemies)

    if targets.empty?
      display_no_valid_targets
      action_fail
    else
      target_enemy = select_enemy_to_attack(targets)
      display_summary
      hit = attack_successful?(target_enemy)
      remove_unconscious(target_enemy)
      damage = resolve_damage(target_enemy) if hit
      display_attack_summary(hit, damage, target_enemy)
    end
  end

  def select_enemy_to_attack(targets)
    puts "Which enemy would #{current_player.name} like to attack?"
    choose_target_menu_with_location(targets)
  end

  def display_no_valid_targets
    display_ineffective_action do
      puts "No enemies are within range. Try moving closer first or"
      puts "equipping a weapon with greater range."
      puts
      puts 'Please select another option...'
    end
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
