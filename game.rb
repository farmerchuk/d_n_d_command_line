# Classes needed

Player # individual
PlayerList # list of players and methods for advancing turns
PlayerAction # keeps info on player's choice and associated message
Area # keeps description and info about how locations are connected
Location #keeps description and info about people, items, etc.


# Game logic

def initialize
  @players
  @player
  @area
  @location
end


def run
  dm_describes_scene # => nil

  loop do
    dm_selects_player_turn # => nil
    dm_describes_scene # => nil
    player_selects_action # => nil
    execute_player_action # => nil
  end
end

def dm_describes_scene # => nil
  player.location.describe # => String
  location.describe_connected_locations # => String
end

def dm_selects_player_turn # => nil
  player = players.pick_list
end

def player_selects_action # => nil
  player.action = player.pick_action # => PlayerAction
end

def execute_player_action # => nil
  case player.action.choice # => nil
  when :move
    player.location = player.action.message
  when :examine
    player.location.describe
  when :search
    player.location.describe_hidden
  when :alert
    player.alert!
  when :skill
    player.use_skill(player.action.message)
  when :item
    player.use_item(player.action.message)
  when :rest
    player.rest!
  when :engage
    player.location.entities(player.action.message)
  end
end
