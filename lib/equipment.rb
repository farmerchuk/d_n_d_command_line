# equipment.rb

class Equipment
  attr_accessor :id, :type, :display_name, :description, :cost,
                :equip_script, :unequip_script, :equipped_by

  def self.build_weapon(weapon_id)
    weapon_data = YAML.load_file('../assets/yaml/weapons.yml')

    weapon = weapon_data.find { |wep| wep['id'] == weapon_id }
    new_weapon = Weapon.new
    new_weapon.id = weapon['id']
    new_weapon.type = weapon['type']
    new_weapon.display_name = weapon['display_name']
    new_weapon.description = weapon['description']
    new_weapon.cost = weapon['cost']
    new_weapon.damage_die = weapon['damage_die']
    new_weapon.range = weapon['range']
    new_weapon.equip_script = weapon['equip_script']
    new_weapon.unequip_script = weapon['unequip_script']
    new_weapon
  end

  def self.build_armor(armor_id)
    armor_data = YAML.load_file('../assets/yaml/armors.yml')

    armor = armor_data.find { |arm| arm['id'] == armor_id }
    new_armor = Armor.new
    new_armor.id = armor['id']
    new_armor.type = armor['type']
    new_armor.display_name = armor['display_name']
    new_armor.description = armor['description']
    new_armor.cost = armor['cost']
    new_armor.armor_class = armor['armor_class']
    new_armor.str_required = armor['str_required']
    new_armor.stealth_penalty = armor['stealth_penalty']
    new_armor.dex_bonus_max =
      armor['dex_bonus_max'] == 'nil' ? nil : armor['dex_bonus_max']
    new_armor.equip_script = armor['equip_script']
    new_armor.unequip_script = armor['unequip_script']
    new_armor
  end

  def self.build_accessory(accessory_id)
    accessory_data = YAML.load_file('../assets/yaml/accessories.yml')

    accessory = accessory_data.find { |acc| acc['id'] == accessory_id }
    new_accessory = Accessory.new
    new_accessory.id = accessory['id']
    new_accessory.type = accessory['type']
    new_accessory.display_name = accessory['display_name']
    new_accessory.description = accessory['description']
    new_accessory.cost = accessory['cost']
    new_accessory.equip_script = accessory['equip_script']
    new_accessory.unequip_script = accessory['unequip_script']
    new_accessory
  end

  def initialize
    @id = nil # String
    @type = nil # String
    @display_name = nil # String
    @description = nil # String
    @cost = nil # Integer
    @equip_script = nil # String
    @unequip_script = nil # String
    @equipped_by = nil # Player
  end

  def checkout_equipment_by(player)
    self.equipped_by = player
  end

  def checkin_equipment
    self.equipped_by = nil
  end

  def classifier
    self.class.to_s
  end

  def to_s
    display_name
  end
end

class Armor < Equipment
  TYPES = %w[light medium heavy shield]

  attr_accessor :armor_class, :str_required, :stealth_penalty,
                :dex_bonus_max

  def initialize
    super
    @armor_class = nil # Integer
    @str_required = nil # Integer
    @stealth_penalty = nil # Boolean
    @dex_bonus_max = nil # Integer
  end

  def display_in_profile
    "#{display_name.ljust(25)}#{type.ljust(15)}#{armor_class.to_s.ljust(20)}#{description}"
  end
end

class Weapon < Equipment
  TYPES = %w[melee ranged]

  attr_accessor :damage_die, :range, :equipped_by

  def initialize
    super
    @type = nil # String
    @damage_die = nil # String ie. 2d6
    @range = nil # Integer
  end

  def display_in_profile
    "#{display_name.ljust(25)}#{type.ljust(15)}#{damage_die.ljust(20)}#{description}"
  end
end

class Accessory < Equipment
  def display_in_profile
    "#{display_name.ljust(25)}#{type.ljust(15)}#{description}"
  end
end

class Item < Equipment
  def display_in_profile
    "#{display_name.ljust(25)}#{description}"
  end
end

class Tool < Equipment
  def display_in_profile
    "#{display_name.ljust(25)}#{description}"
  end
end
