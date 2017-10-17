# event.rb

class Event
  attr_accessor :id, :location, :trigger, :result

  def initialize
    @id = nil
    @location = nil
    @trigger = nil
    @result = nil
  end
end
