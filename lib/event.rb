# event.rb

class Event
  attr_accessor :id, :location_id, :location, :trigger, :description,
                :encounter, :script

  def initialize
    @id = nil # String
    @location_id # String
    @location = nil # Location
    @trigger = nil # String
    @description = nil # String
    @encounter = nil # Encounter
    @script = nil # String
  end

  def to_s
    id
  end
end
