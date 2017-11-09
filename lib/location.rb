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

  def distance_to(location)
    raise ArgumentError unless self.area_id == location.area_id
    return 0 if self.id == location.id

    checked_path_ids = []
    jumps(self, location.id, checked_path_ids)
  end

  def to_s
    display_name
  end

  private

  def jumps(location, target_location_id, checked_path_ids)
    if location.path_ids.any? { |path_id| path_id == target_location_id }
      return 1
    end

    return 0 if checked_path_ids.include?(location.id)

    location.paths.each { |path| checked_path_ids << path.id }

    location.paths.each do |location|
      return 1 + jumps(location, target_location_id, checked_path_ids)
    end
  end
end
