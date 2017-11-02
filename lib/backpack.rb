# backpack.rb

require_relative 'helpers'

class Backpack
  include Helpers::Format

  attr_reader :armors, :weapons, :gears, :tools
  attr_accessor :purse

  def initialize
    @armors = []
    @weapons = []
    @gears = []
    @tools = []
    @purse = nil
  end

  def add(equipment)
    if equipment.instance_of?(Armor)
      armors << equipment
    elsif equipment.instance_of?(Weapon)
      weapons << equipment
    elsif equipment.instance_of?(Gear)
      gears << equipment
    elsif equipment.instance_of?(Tool)
      tools << equipment
    else
      raise ArgumentError, 'No matching equipment handler'
    end
  end

  def view
    sort_equipment
    clear_screen

    puts "Party Equipment:                             GOLD: #{purse}"
    puts '-----------------------------------------------------------------'
    puts
    puts 'WEAPONS'
    puts '-----------------------------------------------------------------'
    puts 'name                     type      damage    equipped by'
    puts
    weapons.each do |weapon|
      print weapon.display_name.ljust(25)
      print weapon.type.ljust(10)
      print weapon.damage_die.ljust(10)
      puts weapon.equipped_by.ljust(20)
    end
    puts
    puts 'ARMOR'
    puts '-----------------------------------------------------------------'
    puts 'name                     type      AC        equipped by'
    puts
    armors.each do |armor|
      print armor.display_name.ljust(25)
      print armor.type.ljust(10)
      print armor.armor_class.to_s.ljust(10)
      puts armor.equipped_by.ljust(20)
    end
    puts
    puts 'GEAR'
    puts '-----------------------------------------------------------------'
    puts 'name                     type'
    puts
    gears.each do |gear|
      print gear.display_name.ljust(25)
      puts gear.type.ljust(10)
    end
    puts
    puts 'TOOLS'
    puts '-----------------------------------------------------------------'
    puts 'name                     type'
    puts
    tools.each do |tool|
      print tool.display_name.ljust(25)
      puts tool.type.ljust(10)
    end
  end

  private

  def sort_equipment
    armors.sort_by { |armor| armor.type }
    weapons.sort_by { |weapon| weapon.type }
    gears.sort_by { |gear| gear.type }
    tools.sort_by { |tool| tool.type }
  end
end
