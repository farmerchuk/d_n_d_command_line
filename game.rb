# game.rb

require_relative 'lib/player_list'
require_relative 'lib/player'

# Game logic

class DND
  def initialize
    @players = PlayerList.new
    player1 = Player.new('Jason', 10, :area1)
    player2 = Player.new('Chris', 10, :area1)
    player3 = Player.new('Louise', 10, :area1)
    @players.add(player1)
    @players.add(player2)
    @players.add(player3)
    @current_player = nil
  end

  def run
    # create_players
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

  def dm_describes_scene # => nil
    current_player.point_of_interest.describe # => String
  end

  def dm_selects_player_turn # => nil
    self.current_player = players.choose_player # => Player
  end

  def player_selects_action # => nil
    current_player.choose_action
  end

  def event_handler # => nil
    Event.new(current_player).run
    current_player.end_turn
  end
end

DND.new.run
