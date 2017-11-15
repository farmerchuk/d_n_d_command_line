# area.rb

class Area
  attr_accessor :id, :locked, :entrance, :display_name, :introduction,
                :description, :map, :locations

  def initialize
    @id = nil # String
    @locked = nil # Boolean
    @entrance = nil # String
    @display_name = nil # String
    @introduction = nil # String
    @description = nil # String
    @map = nil # String
    @locations = [] # Array of Locations
  end

  def add_location(location)
    locations << location
  end

  def unlock!
    self.locked = false
  end

  def unlocked?
    !locked
  end

  def to_s
    display_name
  end

  def display_map
    Menu.clear_screen
    puts 'AREA MAP'
    Menu.draw_line
    puts map
    puts
    puts
  end
end
