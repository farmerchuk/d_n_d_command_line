# backpack.rb

require_relative 'helpers'

class Backpack
  include Helpers::Format

  attr_reader :armors, :weapons, :gears, :tools

  def initialize
    @armors = []
    @weapons = []
    @gears = []
    @tools = []
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

    puts 'Party Equipment:'
    puts '------------------------------------'
    puts
    puts 'Weapons:'
    puts
    weapons.each do |weapon|
      puts weapon.display_name
    end
    puts
    puts 'Armor:'
    puts
    armors.each do |armor|
      puts armor.display_name
    end
    puts
    puts 'Gear:'
    puts
    gears.each do |gear|
      puts gear.display_name
    end
    puts
    puts 'Tools:'
    puts
    tools.each do |tool|
      puts tool.display_name
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
