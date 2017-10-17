# game.rb

require_relative 'lib/player_list'
require_relative 'lib/player'

require 'pry'

# Game logic

class DND
  def initialize
    @players = PlayerList.new
    @current_player = nil
  end

  def run
    create_players
    set_current_player
    # dm_describes_scene # => nil

    loop do
      dm_selects_player_turn # => nil
      # dm_describes_scene # => nil
      player_selects_action # => nil
      # event_handler # => nil
    end
  end

  private

  attr_accessor :players, :current_player

  def create_players
    loop do
      player = create_player
      players.add(player)
      break unless create_another_player?
    end
  end

  def create_player
    player = Player.new

    name = nil
    loop do
      print "What is the player's name: "
      name = gets.chomp
      break unless name =~ /\W/ || name.size < 3
      puts 'Sorry, that is not a valid name...'
    end
    player.name = name

    player
  end

  def create_another_player?
    input = nil
    loop do
      print 'Would you like to add another player? (y/n) '
      input = gets.chomp
      break if ['y', 'n'].include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    input == 'y' ? true : false
  end

  def set_current_player
    self.current_player = players.highest_initiative
  end

  def dm_describes_scene # => nil
    current_player.point_of_interest.describe # => String
  end

  def dm_selects_player_turn # => nil
    self.current_player = players.select_player # => Player
  end

  def player_selects_action # => nil
    current_player.select_action
  end

  def event_handler # => nil
    Event.new(current_player).run
    current_player.end_turn
  end
end

DND.new.run
