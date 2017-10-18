# area.rb

class Area
  attr_accessor :id, :description
  attr_reader :locations

  def initialize
    @id = nil
    @description = nil
    @locations = []
  end

  def <<(location)
    locations << location
  end

  def select
    locations.select { |location| yield(location) }
  end
end
