# point_of_interest.rb

class PointOfInterest
  attr_accessor :description
  attr_reader :events, :points_of_interest

  def initialize
    @id = nil # String
    @description = nil # String
    @events = {} # ie. { move: event_id_1, examine: event_id_2, ... }
    @paths = [] # available paths to other points of interest
  end
end
