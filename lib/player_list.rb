# player_list.rb

class PlayerList
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
    puts 'Please select a player:'
    list_all_players
    choice = nil
    loop do
      choice = gets.chomp.to_i
      break if (0..players.size - 1).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end
    players[choice]
  end

  def highest_initiative
    raise StandardError('PlayerList empty') if players.empty?
    players.sort_by { |player| player.initiative }.last
  end

  private

  attr_reader :players

  def list_all_players
    players.each_with_index { |player, idx| puts "#{idx}. #{player}" }
  end
end
