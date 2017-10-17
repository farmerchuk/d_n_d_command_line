# event_handler.rb

require_relative 'helpers'

class EventHandler
  include Helpers::Format

  attr_accessor :player

  def initialize(current_player)
    @player = current_player
  end

  def run
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
  end

  def player_move
    paths = player.area.select do |loc_id, location|
      player.location.paths.include?(location.id)
    end

    puts 'Where would the player like to move to?'
    paths.each_with_index do |(loc_id, location), idx|
      puts "#{idx}. #{location}"
    end

    choice = nil
    loop do
      choice = prompt.to_i
      break if (0..(paths.size - 1)).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end

    new_location = paths.each_with_index do |(loc_id, location), idx|
      player.location = location if idx == choice
    end
  end
end
