# point_of_interest.rb

class PointOfInterest
  attr_accessor :description
  attr_reader :events, :points_of_interest

  def initialize
    @id = nil # String
    @description = nil # String
    @events = {} # ie. { move: false, examine: true, ... }
    @points_of_interest = [] # ie. { poi4, poi5, poi6 }
  end

  def has(player_action)
    @events[player_action]
  end
end
