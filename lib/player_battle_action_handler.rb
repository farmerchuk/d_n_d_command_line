# player_battle_action_handler.rb

require_relative 'dnd'

class PlayerBattleActionHandler < BattleActionHandler
  include PlayerActionHandler

  attr_accessor :current_player

  def initialize(players, locations, enemies, all_entities)
    super
    @current_player = players.current
  end

  def run_action
    display_summary
    execute_player_action
    current_player.end_action
    Menu.prompt_continue
    display_summary
  end

  def player_selects_action
    loop do
      puts "What action would #{current_player.name} like to take?"
      role = current_player.role.to_s

      case role
      when 'fighter'
        current_player.action = Menu.choose_from_menu(Fighter::BATTLE_ACTIONS)
      when 'rogue'
        current_player.action = Menu.choose_from_menu(Rogue::BATTLE_ACTIONS)
      when 'cleric'
        current_player.action = Menu.choose_from_menu(Cleric::BATTLE_ACTIONS)
      when 'wizard'
        current_player.action = Menu.choose_from_menu(Wizard::BATTLE_ACTIONS)
      end

      break if action_possible?('battle')
      display_summary
      display_action_error
    end
  end

  def player_attack
    target_enemy = select_enemy_to_attack
    hit = attack_successful?(target_enemy)
    damage = resolve_damage(target_enemy) if hit
    display_attack_summary(hit, damage, target_enemy)
  end

  def select_enemy_to_attack
    puts "Which enemy would #{current_player.name} like to attack?"
    targets = targets_in_range(enemies)
    choose_enemy_menu_with_location(targets)
  end

  def choose_enemy_menu_with_location(enemies)
    enemies.each_with_index do |enemy, idx|
      puts "#{idx}. #{enemy} at #{enemy.location.display_name} " +
           "(#{enemy.current_hp} HP)"
    end

    choice = nil
    loop do
      choice = Menu.prompt.to_i
      break if (0..enemies.size - 1).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end
    enemies[choice]
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
