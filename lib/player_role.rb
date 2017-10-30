# player_role.rb

class PlayerRole
  ROLES = %w[fighter]

  attr_accessor :str, :dex, :con, :int, :wis, :cha,
                :level, :hit_die, :proficiency

  def initialize
    @level = 1
  end

  def to_s
    self.class.to_s
  end
end

class Fighter < PlayerRole
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
