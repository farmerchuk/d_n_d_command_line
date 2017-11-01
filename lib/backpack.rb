# backpack.rb

require_relative 'equipment'
require 'pry'

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
      raise ArgumentError
    end
  end
end

backpack = Backpack.new
weapon = Weapon.new
armor = Armor.new
tool = Tool.new
gear = Gear.new

backpack.add(weapon)
backpack.add(weapon)
backpack.add(armor)
backpack.add(gear)
backpack.add(tool)
