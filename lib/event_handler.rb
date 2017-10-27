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
    case player.action
    when 'move' then player_move
    when 'examine' then player_examine
    when 'search' then player_search
    when 'alert' then player_alert
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'engage' then player_engage
    end

    no_event_msg if no_event_matching_player_action?
  end

  def player_move
    available_locations = player.location.paths
    list_locations(available_locations)
    choice = choose_num(0..(available_locations.size))
    set_player_location(available_locations, choice)

    puts "#{player} is now at the #{player.location.display_name}"
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

  def player_examine
    puts event.description
  end

  def player_search
    puts event.description
  end

  def player_alert
    puts "Player is on alert"
    prompt_continue
  end

  def player_use_skill
    puts "Player uses a skill"
    prompt_continue
  end

  def player_use_item
    puts "Player uses an item"
    prompt_continue
  end

  def player_rest
    puts "Player rests"
    prompt_continue
  end

  def player_engage
    puts "Player engages with something or someone"
    prompt_continue
  end
end
