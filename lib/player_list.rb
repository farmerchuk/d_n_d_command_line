# player_list.rb

require_relative 'dnd'

class PlayerList
  include Helpers::Data

  attr_reader :players

  def initialize
    @players = []
  end

  def each
    raise ArgumentError unless block_given?
    players.each { |player| yield player }
  end

  def add(player)
    raise ArgumentError unless player.instance_of?(Player)
    players << player
  end

  def size
    players.size
  end

  def [](index)
    players[index]
  end

  def first
    players[0]
  end

  def to_a
    players
  end

  def current
    players.each do |player|
      return player if player.current_turn
    end
  end

  def set_current_turn!(current_player)
    unset_current_turn_all_players!
    current_player.set_current_turn!
  end

  def set_new_area(area, locations)
    players.each do |player|
      player.area = area
      player.location = retrieve(area.entrance, locations)
    end
  end

  def unset_current_turn_all_players!
    players.each { |player| player.unset_current_turn! }
  end

  def rest
    clear_all_status_effects
    reset_casts
    reset_current_hps

    puts "The party rests and recovers from their adventures."
    puts
    puts "- All status effects cleared"
    puts "- Current HP reset to max"
    puts "- Spell user casts reset to max"
  end

  def clear_all_battle_status_effects
    players.each do |player|
      player.clear_all_battle_status_effects
    end
  end

  def clear_all_status_effects
    players.each do |player|
      player.clear_all_status_effects
    end
  end

  def reset_current_hps
    players.each do |player|
      player.set_current_hp_to_max
    end
  end

  def reset_casts
    players.each do |player|
      player.reset_casts_remaining if player.caster
    end
  end

  def highest_initiative
    raise 'PlayerList empty' if players.empty?
    players.sort_by { |player| player.initiative }.last
  end

  def all_hidden?
    players.all? { |player| player.conditions.include?('hidden') }
  end
end
