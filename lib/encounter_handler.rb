# encounter_handler.rb

require_relative 'dnd'

class EncounterHandler
  include Helpers::Data

  attr_reader :engagement_ids, :players, :current_player, :areas, :locations

  def initialize(encounter_id, players, areas, locations)
    encounters_data = YAML.load_file('../assets/yaml/encounters.yml')

    @engagement_ids = get_engagement_ids(encounter_id, encounters_data)
    @players = players
    @current_player = players.current
    @areas = areas
    @locations = locations
  end

  def run
    Menu.prompt_encounter_start

    engagement_ids.each do |engagement_id|
      if get_engagement_id_prefix(engagement_id) == 'battle'
        BattleHandler.new(engagement_id, players, locations).run
      elsif get_engagement_id_prefix(engagement_id) == 'dialogue'
        DialogueHandler.new(engagement_id, players, areas, locations).run
      elsif get_engagement_id_prefix(engagement_id) == 'loot'
        LootHandler.new(engagement_id, players).run
      end

      break if players.all_dead?
    end

    clean_up
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

  def clean_up
    players.set_current_turn!(current_player)
    players.clear_all_battle_status_effects
  end
end
