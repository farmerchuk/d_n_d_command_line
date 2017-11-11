# area.rb

class Area
  attr_accessor :id, :description, :map
  attr_reader :locations

  def initialize
    @id = nil # String
    @description = nil # String
    @map = nil # String
    @locations = [] # Array of Locations
  end

  def add_location(location)
    locations << location
  end

  def to_s
    id
  end
end
