# area.rb

class Area
  attr_accessor :id, :description
  attr_reader :locations

  def initialize
    @id = nil
    @description = nil
    @locations = {}
  end

  def get_location_from_id(id)
    locations[id]
  end

  def select
    locations.select { |loc_id, details| yield(loc_id, details) }
  end
end
