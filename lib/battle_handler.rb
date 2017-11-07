# battle_handler.rb

require_relative 'action_handler'
require_relative 'battle'
require_relative 'player'

require 'pry'

class BattleHandler
  include Helpers::Prompts
  include Helpers::Menus
  include Helpers::Displays
  include Helpers::Format

  attr_reader :players, :current_player, :locations,
              :battle, :enemies, :all_entities

  def initialize(engagement_id, players, current_player, locations)
    battles_data = YAML.load_file('../assets/yaml/battles.yml')

    @players = players
    @current_player = current_player
    @locations = locations
    @battle = get_battle(engagement_id, battles_data)
    battle.build_enemies
    @enemies = battle.enemies

    @all_entities = players.to_a + battle.enemies
    sort_all_entities_by_initiative!
  end

  def run
    battle_introduction

    all_entities.cycle do |entity|
      break if all_players_dead? || all_enemies_dead?
      next if entity.current_hp <= 0

      if entity.instance_of?(Player)
        player_turn(entity)
      else
        puts 'Enemy attacks!'
        prompt_continue
      end
    end
  end

  private

  def get_battle(engagement_id, battles_data)
    battles_data.each do |battle|
      if battle['id'] == engagement_id
        new_battle = Battle.new(locations)
        new_battle.id = battle['id']
        new_battle.introduction = battle['introduction']
        new_battle.enemy_and_location_ids = battle['enemy_and_location_ids']
        return new_battle
      end
    end
  end

  def sort_all_entities_by_initiative!
    all_entities.sort_by! { |entity| entity.initiative }.reverse!
  end

  def all_players_dead?
    players.to_a.all? { |player| player.current_hp <= 0 }
  end

  def all_enemies_dead?
    battle.enemies.all? { |enemy| enemy.current_hp <= 0 }
  end

  def battle_introduction
    display_player_summary(players, current_player)
    puts battle.introduction
    prompt_continue
  end

  def player_turn(current_player)
    BattleActionHandler.new(
      players,
      current_player,
      locations,
      enemies).run
  end

  def display_battle_details
    display_player_summary

  end
end
