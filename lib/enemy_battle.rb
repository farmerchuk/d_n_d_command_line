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
    display_summary
    targets = targets_in_range(players.to_a)

    if targets.empty?
      move_towards_closest_player
      Menu.prompt_continue
      display_summary
      targets = targets_in_range(players.to_a)
      attack(targets) unless targets.empty?
    else
      attack(targets)
    end
    display_summary
    Menu.prompt_end_player_turn
  end

  def attack(targets)
    target_player = targets.sample
    hit = attack_successful?(target_player)
    damage = resolve_damage(target_player) if hit
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

    current_player.location.paths.each do |location|
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