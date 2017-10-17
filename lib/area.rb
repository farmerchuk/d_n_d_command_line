# area.rb
# keeps description and info about how locations are connected

class Area
  attr_accessor :id, :description
  attr_reader :locations

  def initialize
    @id = nil
    @description = nil
    @locations = {}
  end
end
