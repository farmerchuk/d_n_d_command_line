# battle_handler.rb

require_relative 'battle'

require 'pry'

class BattleHandler
  attr_reader :battle, :players, :locations

  def initialize(engagement_id, players, locations)
    battles_data = YAML.load_file('../assets/yaml/battles.yml')

    @locations = locations
    @battle = get_battle(engagement_id, battles_data)
    @players = players

    battle.build_enemies
  end

  def run
    binding.pry
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
end
