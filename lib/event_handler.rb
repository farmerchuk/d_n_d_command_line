# event_handler.rb

class EventHandler
  def initialize(current_player)
    @player = current_player
    @player_action = current_player.action
    @player_location = player.location
    @event = matching_event
  end

  def run
    unless event
      puts 'Ineffective action...'
      puts
    else
      event.each_value do |details|
        puts details['result']
      end
      puts
    end
  end

  private

  attr_reader :player, :player_action, :player_location, :event

  def matching_event
    events = player_location.events
    event = events.select do |_, details|
      details['trigger'] == player_action
    end
    event.empty? ? nil : event
  end
end
