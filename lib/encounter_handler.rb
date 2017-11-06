# encounter_handler.rb

require_relative 'helpers'
require_relative 'battle_handler'
require_relative 'conversation_handler'

require 'yaml'

class EncounterHandler
  include Helpers::Data

  attr_reader :engagement_ids, :players, :locations

  def initialize(encounter_id, players, locations)
    encounters_data = YAML.load_file('../assets/yaml/encounters.yml')
    @engagement_ids = get_engagement_ids(encounter_id, encounters_data)
    @players = players
    @locations = locations
  end

  def run
    engagement_ids.each do |engagement_id|
      if get_engagement_id_prefix(engagement_id) == 'battle'
        BattleHandler.new(engagement_id, players, locations).run
      elsif get_engagement_id_prefix(engagement_id) == 'conversation'
        ConversationHandler.new(engagement_id, players, locations).run
      end
    end
  end

  private

  def get_engagement_ids(encounter_id, encounters_data)
    encounters_data.each do |encounter|
      if encounter['id'] == encounter_id
        return encounter['engagement_ids']
      end
    end
  end

  def get_engagement_id_prefix(engagement_id)
    engagement_id.split('_').first
  end
end
