# battle_handler.rb

require_relative 'battle'

require 'pry'

class BattleHandler
  attr_reader :battle

  def initialize(engagement_id)
    battles_info = YAML.load_file('../assets/yaml/battles.yml')
    @battle = get_battle(engagement_id, battles_info)
  end

  def run
    
  end

  private

  def get_battle(engagement_id, battles_info)
    battles_info.each do |battle|
      if battle['id'] == engagement_id
        new_battle = Battle.new
        new_battle.id = battle['id']
        new_battle.description = battle['description']
        new_battle.enemy_ids = battle['enemy_ids']
        return new_battle
      end
    end
  end
end
