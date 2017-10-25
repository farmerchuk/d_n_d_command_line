# location.rb

class Location
  attr_accessor :id, :area, :display_name, :description, :events, :paths

  def initialize
    @id = nil # String
    @area = nil # Area
    @display_name = nil # String
    @description = nil # String
    @events = [] # events that can occur based on player action
    @paths = [] # available paths to other locations
  end

  def to_s
    display_name
  end
end
