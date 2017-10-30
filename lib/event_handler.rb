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
    player.end_action
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
    case player.action # resolves actions
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    end

    if no_event_matching_player_action?
      no_event_msg
    else
      puts event.description

      case player.action # resolves events
      when 'move' then move_event
      when 'examine' then examine_event
      when 'search' then search_event
      when 'wait' then wait_event
      when 'skill' then use_skill_event
      when 'item' then use_item_event
      when 'rest' then rest_event
      when 'engage' then engage_event
      end
    end
  end

  def no_event_matching_player_action?
    !event
  end

  def player_move
    puts "Where would #{player.name} like to move to?"
    available_locations = player.location.paths
    player.location = choose_from_menu(available_locations)

    puts "#{player} is now at the #{player.location.display_name}"
    puts
  end

  def player_wait
    puts "#{player} is on alert!"
    puts
  end

  def player_use_skill
    puts "#{player} uses a skill."
    puts
  end

  def player_use_item
    puts "#{player} uses an item."
    puts
  end

  def player_rest
    puts "#{player} rests."
    puts
  end

  def move_event

  end

  def examine_event

  end

  def search_event

  end

  def wait_event

  end

  def use_skill_event

  end

  def use_item_event

  end

  def rest_event

  end

  def engage_event

  end
end
