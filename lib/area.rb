# area.rb

class Area
  attr_accessor :id, :entrance, :display_name, :description, :map
  attr_reader :locations

  def initialize
    @id = nil # String
    @entrance = nil # String
    @display_name = nil # String
    @description = nil # String
    @map = nil # String
    @locations = [] # Array of Locations
  end

  def add_location(location)
    locations << location
  end

  def to_s
    display_name
  end
end
