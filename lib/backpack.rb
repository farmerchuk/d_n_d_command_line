# backpack.rb

class Backpack
  attr_reader :armor, :weapons, :gear, :tools

  def initialize
    @armor = []
    @weapons = []
    @gear = []
    @tools = []
  end

  def add(equipment)
    if equipment.instance_of?(Armor)
      armor << equipment
    elsif equipment.instance_of?(Weapon)
      weapons << equipment
    elsif equipment.instance_of?(Gear)
      gear << equipment
    elsif equipment.instance_of?(Tool)
      tools << equipment
    else
      raise ArgumentError, 'No matching equipment handler'
    end
  end
end
