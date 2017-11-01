# equipment.rb

class Equipment
  attr_accessor :id, :display_name, :description, :cost, :script

  def initialize
    @id = nil # String
    @display_name = nil # String
    @description = nil # String
    @cost = nil # Integer
    @script = nil # String
  end
end

class Armor < Equipment
  TYPES = %w[light medium heavy shield]

  attr_accessor :type, :armor_class, :str_required, :stealth_penalty,
                :dex_bonus, :dex_bonus_max

  def initialize
    super
    @type = nil # String
    @armor_class = nil # Integer
    @str_required = nil # Integer
    @stealth_penalty = nil # Boolean
    @dex_bonus = nil # Boolean
    @dex_bonus_max = nil # Integer
  end
end

class Weapon < Equipment
  TYPES = %w[melee ranged]

  def initialize
    super
    @type = nil # String
    @damage_die = nil # Integer
  end

end

class Gear < Equipment; end

class Tool < Equipment; end
