# backpack.rb

require_relative 'dnd'

class Backpack
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

  def all_equipment
    all = armors + weapons + gears + tools
    all.sort_by! { |equipment| equipment.classifier }
  end

  def all_unequipped_equipment
    all_equipment.select { |equipment| equipment.equipped_by.nil? }
  end

  def view
    sort_all_equipment_by_type!

    Menu.clear_screen
    puts "Party Equipment:"
    Menu.draw_line
    puts "GOLD: #{purse}"
    puts
    puts
    puts 'WEAPONS'
    Menu.draw_line
    puts 'NAME                     TYPE        DAMAGE      EQUIPPED BY         SPECIAL EFFECTS'
    puts
    weapons.each do |weapon|
      puts "#{weapon.display_name.ljust(25)}" +
           "#{weapon.type.ljust(12)}" +
           "#{weapon.damage_die.ljust(12)}" +
           "#{weapon.equipped_by.name.ljust(20) if weapon.equipped_by}" +
           "#{weapon.description}"
    end
    puts
    puts
    puts 'ARMOR'
    Menu.draw_line
    puts 'NAME                     TYPE        A/C         EQUIPPED BY         SPECIAL EFFECTS'
    puts
    armors.each do |armor|
      puts "#{armor.display_name.ljust(25)}" +
           "#{armor.type.ljust(12)}" +
           "#{armor.armor_class.to_s.ljust(12)}" +
           "#{armor.equipped_by.name.ljust(20) if armor.equipped_by}" +
           "#{armor.description}"
    end
    puts
    puts
    puts 'GEAR'
    Menu.draw_line
    puts 'NAME                     TYPE'
    puts
    gears.each do |gear|
      print gear.display_name.ljust(25)
      puts gear.type.ljust(10)
    end
    puts
    puts
    puts 'TOOLS'
    Menu.draw_line
    puts 'NAME                     TYPE'
    puts 
    tools.each do |tool|
      print tool.display_name.ljust(25)
      puts tool.type.ljust(10)
    end
    puts
  end

  def view_equippable(current_player)
    Menu.clear_screen
    puts "CURRENTLY EQUIPPED BY: #{current_player}"
    Menu.draw_line
    puts 'name                     class             details'
    puts '----                     -----             -------'
    current_player.all_equipped.each do |eq|
      puts "#{eq.display_name.ljust(25)}#{eq.classifier.ljust(18)}" +
      if eq.instance_of?(Weapon)
        "#{eq.damage_die.ljust(8)}damage"
      elsif eq.instance_of?(Armor)
        "#{eq.armor_class.to_s.ljust(8)}AC"
      end
    end
    puts
    puts
    puts 'ALL AVAILABLE EQUIPMENT'
    Menu.draw_line
    puts 'name                     class             details'
    puts '----                     -----             -------'
    all_unequipped_equipment.each do |eq|
      puts "#{eq.display_name.ljust(25)}#{eq.classifier.ljust(18)}" +
      if eq.instance_of?(Weapon)
        "#{eq.damage_die.ljust(8)}damage"
      elsif eq.instance_of?(Armor)
        "#{eq.armor_class.to_s.ljust(8)}AC"
      end
    end
    puts
    puts
    puts 'EQUIPMENT DETAILS'
    Menu.draw_line
  end

  private

  def sort_all_equipment_by_type!
    armors.sort_by! { |armor| armor.type }
    weapons.sort_by! { |weapon| weapon.type }
    gears.sort_by! { |gear| gear.type }
    tools.sort_by! { |tool| tool.type }
  end
end
