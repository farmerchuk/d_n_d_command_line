# player_role.rb

class PlayerRole
  ROLES = %w[fighter rogue cleric wizard]

  attr_accessor :str, :dex, :con, :int, :wis, :cha,
                :level, :hit_die, :proficiency

  def initialize
    @level = 1
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Fighter < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait skill item equip rest engage]
  BATTLE_ACTIONS = %w[move attack wait skill item equip]

  def initialize
    super
    @str = 14
    @dex = 16
    @con = 15
    @int = 11
    @wis = 13
    @cha = 9
    @hit_die = 10
    @proficiency = ['str', 'con']
  end
end

class Rogue < PlayerRole
  EXPLORE_ACTIONS = %w[move examine search wait skill item equip rest engage]
  BATTLE_ACTIONS = %w[move attack wait skill item equip]

  def initialize
    super
    @str = 8
    @dex = 16
    @con = 12
    @int = 13
    @wis = 10
    @cha = 16
    @hit_die = 8
    @proficiency = ['dex', 'int']
  end
end

class Cleric < PlayerRole
  EXPLORE_ACTIONS = %w[move magic examine search wait skill item equip rest engage]
  BATTLE_ACTIONS = %w[move attack magic wait skill item equip]

  def initialize
    super
    @str = 14
    @dex = 8
    @con = 15
    @int = 10
    @wis = 16
    @cha = 12
    @hit_die = 8
    @proficiency = ['wis', 'cha']
  end
end

class Wizard < PlayerRole
  EXPLORE_ACTIONS = %w[move magic examine search wait skill item equip rest engage]
  BATTLE_ACTIONS = %w[move attack magic wait skill item equip]

  def initialize
    super
    @str = 10
    @dex = 15
    @con = 14
    @int = 16
    @wis = 12
    @cha = 8
    @hit_die = 6
    @proficiency = ['int', 'wis']
  end
end
