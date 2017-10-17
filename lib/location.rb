# location.rb

class Location
  attr_accessor :id, :area_id, :description, :events, :paths

  def initialize
    @id = nil # String
    @area_id = nil #String
    @description = nil # String
    @events = {} # ie. { move: event_id_1, examine: event_id_2, ... }
    @paths = [] # available paths to other locations
  end
end
