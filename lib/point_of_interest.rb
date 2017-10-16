# point_of_interest.rb

class PointOfInterest
  attr_accessor :description
  attr_reader :events, :points_of_interest

  def initialize
    @id = nil # String
    @description = nil # String
    @events = {} # ie. { move: event_id_1, examine: event_id_2, ... }
    @points_of_interest = [] # ie. [ poi_id_1, poi_id_2, ... ]
  end
end
