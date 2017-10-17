# area.rb
# keeps description and info about how locations are connected

class Area
  attr_reader :points_of_interest

  def initialize
    @points_of_interest = []
  end
end
