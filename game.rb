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
    @area = nil
    @location = nil
  end

  def run
    # create_players
    # dm_describes_scene # => nil

    loop do
      dm_selects_player_turn # => nil
      # dm_describes_scene # => nil
      player_selects_action # => nil
      execute_player_action # => nil
    end
  end

  private

  attr_accessor :players, :current_player

  def dm_describes_scene # => nil
    current_player.location.describe # => String
    location.describe_connected_locations # => String
  end

  def dm_selects_player_turn # => nil
    self.current_player = players.choose_player # => Player
  end

  def player_selects_action # => nil
    current_player.choose_action
  end

  def execute_player_action # => nil
    case current_player.action # => nil
    when :move
      # code
    when :examine
      current_player.location.describe
    when :search
      current_player.location.describe_hidden
    when :alert
      current_player.alert!
    when :skill
      # code
    when :item
      # code
    when :rest
      current_player.rest!
    when :engage
      #code
    end
    current_player.action = nil
  end
end

DND.new.run
