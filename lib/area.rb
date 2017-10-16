# area.rb
# keeps description and info about how locations are connected

class Area
  def initialize
    @paths = {} # ie. { poi1: [poi2, poi3], ... }
  end
end
