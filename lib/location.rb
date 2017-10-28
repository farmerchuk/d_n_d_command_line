# location.rb

class Location
  attr_accessor :id, :area, :area_id, :display_name, :description, :events,
                :path_ids, :paths

  def initialize
    @id = nil # String
    @area_id = nil # String
    @area = nil # Area
    @display_name = nil # String
    @description = nil # String
    @path_ids = [] # Array
    @paths = [] # Array of Locations
  end

  def add_path(location)
    paths << location
  end

  def to_s
    display_name
  end
end
