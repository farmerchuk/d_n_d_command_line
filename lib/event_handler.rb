# event_handler.rb

require_relative 'helpers'

class EventHandler
  include Helpers::Format

  attr_accessor :player, :events, :event

  def initialize(current_player, events)
    @player = current_player
    @events = events
    @event = set_event
  end

  def run
    resolve_player_action
    prompt_continue
    player.end_turn
  end

  def set_event
    events.each do |event|
      if event.trigger == player.action && event.location == player.location
        return event
      end
    end
    nil
  end

  def resolve_player_action
    player_move if player.action == 'move'

    if no_event_matching_player_action?
      no_event_msg
    else
      puts event.description

      case player.action
      when 'move' then move_event
      when 'examine' then examine_event
      when 'search' then search_event
      when 'alert' then alert_event
      when 'skill' then use_skill_event
      when 'item' then use_item_event
      when 'rest' then rest_event
      when 'engage' then engage_event
      end
    end
  end

  def player_move
    available_locations = player.location.paths
    list_locations(available_locations)
    choice = choose_num(0..(available_locations.size))
    set_player_location(available_locations, choice)

    puts "#{player} is now at the #{player.location.display_name}"
    puts
  end

  def list_locations(locations)
    puts 'Where would the player like to move to?'
    locations.each_with_index do |location, idx|
      puts "#{idx}. #{location.display_name}"
    end
    puts "#{locations.size}. Stay where you are"
  end

  def set_player_location(locations, choice)
    locations.each_with_index do |location, idx|
      player.location = location if idx == choice
    end
  end

  def no_event_matching_player_action?
    !event
  end

  def move_event

  end

  def examine_event

  end

  def search_event

  end

  def alert_event
    puts "Player is on alert"
  end

  def use_skill_event
    puts "Player uses a skill"
  end

  def use_item_event
    puts "Player uses an item"
  end

  def rest_event
    puts "Player rests"
  end

  def engage_event
    puts "Player engages with something or someone"
  end
end
