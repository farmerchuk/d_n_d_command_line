# event_handler.rb

require_relative 'helpers'

class EventHandler
  include Helpers::Format

  attr_accessor :player, :event

  def initialize(current_player)
    @player = current_player
    @event = set_event
  end

  def run
    if player.action == 'move'
      player_move
    elsif !event_matching_player_action?
      ineffective_action_msg
    else
      puts event['description']
      resolve_player_action
      prompt_continue
    end

    player.end_turn
  end

  def set_event
    events = player.location.events

    events.select do |event|
      event['trigger'] == player.action
    end.first
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
    available_locations = player.area.select do |location|
      player.location.paths.include?(location.id)
    end

    puts 'Where would the player like to move to?'
    available_locations.each_with_index do |location, idx|
      puts "#{idx}. #{location}"
    end
    puts "#{available_locations.size}. Stay where you are"

    choice = nil
    loop do
      choice = prompt.to_i
      break if (0..(available_locations.size)).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end

    available_locations.each_with_index do |location, idx|
      player.location = location if idx == choice
    end
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
