# equipment.rb

class Equipment
  attr_accessor :id, :type, :display_name, :description, :cost, :script

  def initialize
    @id = nil # String
    @type = nil # String
    @display_name = nil # String
    @description = nil # String
    @cost = nil # Integer
    @script = nil # String
  end
end

class Armor < Equipment
  TYPES = %w[light medium heavy shield]

  attr_accessor :armor_class, :str_required, :stealth_penalty,
                :dex_bonus, :dex_bonus_max, :equipped_by

  def initialize
    super
    @armor_class = nil # Integer
    @str_required = nil # Integer
    @stealth_penalty = nil # Boolean
    @dex_bonus = nil # Boolean
    @dex_bonus_max = nil # Integer
    @equipped_by = nil # Player
  end
end

class Weapon < Equipment
  TYPES = %w[melee ranged]

  attr_accessor :damage_die, :equipped_by

  def initialize
    super
    @type = nil # String
    @damage_die = nil # String ie. 2d6
    @equipped_by = nil # Player
  end

end

class Gear < Equipment; end

class Tool < Equipment; end
