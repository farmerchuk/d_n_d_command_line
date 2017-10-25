# event.rb

class Event
  attr_accessor :id, :location, :trigger, :description, :encounter

  def initialize
    @id = nil # String
    @location = nil # Location
    @trigger = nil # String
    @description = nil # String
    @encounter = nil # Encounter
  end
end
