# event.rb

class Event
  attr_accessor :id, :location, :trigger, :description, :encounter

  def initialize
    @id = nil
    @location = nil # Location
    @trigger = nil
    @description = nil
    @encounter = nil # Encounter
  end
end
