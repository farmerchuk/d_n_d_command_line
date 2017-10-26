# player_list.rb

require_relative 'helpers'

class PlayerList
  include Helpers::Format

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

  def select_player # => Player
    puts 'Which player would like to take a turn?'
    list_all_players
    choice = choose_num(0..players.size - 1)
    puts
    players[choice]
  end

  def highest_initiative
    raise 'PlayerList empty' if players.empty?
    players.sort_by { |player| player.initiative }.last
  end

  private

  attr_reader :players

  def list_all_players
    players.each_with_index { |player, idx| puts "#{idx}. #{player}" }
  end
end
