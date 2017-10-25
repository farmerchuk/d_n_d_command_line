# area.rb

class Area
  attr_accessor :id, :description
  attr_reader :locations

  def initialize
    @id = nil # String
    @description = nil # String
    @locations = [] # Array of Locations
  end

  def <<(location)
    locations << location
  end

  def select
    locations.select { |location| yield(location) }
  end
end
