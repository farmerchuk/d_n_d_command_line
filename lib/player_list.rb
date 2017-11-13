# player_list.rb

class PlayerList
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

  def unset_current_turn_all_players!
    players.each { |player| player.unset_current_turn! }
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
end
