# event.rb

class Event
  attr_accessor :id, :location, :trigger, :description, :encounter

  def initialize
    @id = nil
    @location = nil
    @trigger = nil
    @description = nil
    @encounter = nil
  end
end
