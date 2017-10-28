# player_list.rb

require_relative 'helpers'

class PlayerList
  include Helpers::Format

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

  def to_a
    players
  end

  def highest_initiative
    raise 'PlayerList empty' if players.empty?
    players.sort_by { |player| player.role.initiative }.last
  end
end
