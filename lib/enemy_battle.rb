# enemy_battle.rb

require_relative 'dnd'

class EnemyBattle
  include GeneralBattleActions

  attr_accessor :current_player, :players, :locations, :all_entities

  def initialize(enemy, players, locations, all_entities)
    @current_player = enemy
    @players = players
    @locations = locations
    @all_entities = all_entities
  end

  def run
    current_player.start_turn
    conditions = current_player.conditions

    display_summary

    if condition_prevents_attack?(conditions)
      display_attack_conditions(conditions)
      Menu.prompt_continue
    else
      targets = targets_in_range(players.to_a)
      targets.empty? ? move_then_attack : attack(targets)
    end

    display_summary
    Menu.prompt_end_player_turn
  end

  def condition_prevents_attack?(conditions)
    conditions.include?('unconscious')
  end

  def display_attack_conditions(conditions)
    if conditions.include?('unconscious')
      puts "#{current_player} is unconscious and cannot attack or move."
    end
  end

  def move_then_attack
    move_towards_closest_player
    Menu.prompt_continue
    display_summary
    targets = targets_in_range(players.to_a)
    attack(targets) unless targets.empty?
  end

  def attack(targets)
    target_player = targets.sample
    hit = attack_successful?(target_player)
    damage = nil
    clear_conditions_if_hurt(target_player) do
      damage = resolve_damage(target_player) if hit
    end
    display_attack_summary(hit, damage, target_player)
    Menu.prompt_continue
  end

  def targets_in_range(targets)
    targets.select do |target|
      weapon_range = current_player.equipped_weapon.range
      distance = current_player.location.distance_to(target.location)
      weapon_range >= distance && target.alive?
    end
  end

  def move_towards_closest_player
    current_player.location = get_next_location
    puts "#{current_player} moves to #{current_player.location.display_name}."
    puts
  end

  def get_next_location
    distances = Hash.new { |hash, key| hash[key] = [] }

    current_player.available_paths.each do |location|
      players.each do |player|
        distance = location.distance_to(player.location)
        distances[distance] << location
      end
    end

    distances.sort.first[1].sample
  end

  def display_attack_summary(hit, damage, target)
    if hit
      puts "#{current_player}'s attack was successful!"
      puts
      puts "The #{current_player} hit #{target} with a " +
           "#{current_player.equipped_weapon.display_name} " +
           "and dealt #{damage} damage."
    else
      puts "#{current_player} attacks #{target} with a " +
           "#{current_player.equipped_weapon.display_name} and missed!"
    end
  end
end
