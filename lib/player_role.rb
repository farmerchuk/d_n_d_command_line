# player_role.rb

class PlayerRole
  ROLES = %w[fighter rogue cleric wizard]

  attr_accessor :str, :dex, :con, :int, :wis, :cha,
                :level, :hit_die, :caster, :proficiency

  def initialize
    @level = 1
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Fighter < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait item equip talk]
  BATTLE_ACTIONS = %w[move attack wait item equip]

  def initialize
    super
    @str = 16
    @dex = 13
    @con = 15
    @int = 11
    @wis = 13
    @cha = 10
    @hit_die = 10
    @caster = false
    @proficiency = ['str', 'con']
  end
end

class Rogue < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait item equip talk hide]
  BATTLE_ACTIONS = %w[move attack wait item equip hide]

  def initialize
    super
    @str = 8
    @dex = 16
    @con = 12
    @int = 13
    @wis = 12
    @cha = 14
    @hit_die = 8
    @caster = false
    @proficiency = ['dex', 'int']
  end
end

class Cleric < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait item equip talk magic]
  BATTLE_ACTIONS = %w[move attack wait item equip magic]

  attr_accessor :casts_max, :casts_remaining

  def initialize
    super
    @str = 13
    @dex = 8
    @con = 14
    @int = 10
    @wis = 16
    @cha = 15
    @hit_die = 8
    @caster = true
    @casts_max = 2
    @casts_remaining = casts_max
    @proficiency = ['wis', 'cha']
  end
end

class Wizard < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait item equip talk magic]
  BATTLE_ACTIONS = %w[move attack wait item equip magic]

  attr_accessor :casts_max, :casts_remaining

  def initialize
    super
    @str = 10
    @dex = 15
    @con = 14
    @int = 16
    @wis = 12
    @cha = 8
    @hit_die = 6
    @caster = true
    @casts_max = 2
    @casts_remaining = casts_max
    @proficiency = ['int', 'wis']
  end
end
