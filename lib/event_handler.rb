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
    if player.action == 'move'
      player_move
    elsif !event_matching_player_action?
      ineffective_action_msg
    else
      puts event.description
      resolve_player_action
    end

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
    when 'examine' then player_examine
    when 'search' then player_search
    when 'alert' then player_alert
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'engage' then player_engage
    end
  end

  def player_move
    available_locations = player.location.paths

    puts 'Where would the player like to move to?'
    available_locations.each_with_index do |location, idx|
      puts "#{idx}. #{location.display_name}"
    end
    puts "#{available_locations.size}. Stay where you are"

    choice = choose_num(0..(available_locations.size))

    available_locations.each_with_index do |location, idx|
      player.location = location if idx == choice
    end

    puts
    puts "#{player} is now at the #{player.location.display_name}"
  end

  def event_matching_player_action?
    !!event
  end

  def player_examine
    # TBD
  end

  def player_search
    # TBD
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
