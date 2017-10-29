# player_role.rb

class PlayerRole
  ROLES = %w[fighter]

  ABILITY_MODS = { 1 => -5, 2 => -4, 3 => -4, 4 => -3, 5 => -3,
                   6 => -2, 7 => -2, 8 => -1, 9 => -1, 10 => 0,
                   11 => 0, 12 => 1, 13 => 1, 14 => 2, 15 => 2,
                   16 => 3, 17 => 3, 18 => 4, 19 => 4, 20 => 5,
                   21 => 5, 22 => 6, 23 => 6, 24 => 7, 25 => 7,
                   26 => 8, 27 => 8, 29 => 9, 30 => 10 }

   PROFICIENCY_BONUS = { 1 => 2, 2 => 2, 3 => 2, 4 => 2,
                         5 => 3, 6 => 3, 7 => 3, 8 => 3,
                         9 => 4, 10 => 4, 11 => 4, 12 => 4,
                         13 => 5, 14 => 5, 15 => 5, 16 => 5,
                         17 => 6, 18 => 6, 19 => 6, 20 => 6 }

  attr_accessor :str, :dex, :con, :int, :wis, :cha,
                :level, :hit_die, :current_hp

  def initialize
    @level = 1
  end

  def str_mod
    ABILITY_MODS[str]
  end

  def dex_mod
    ABILITY_MODS[dex]
  end

  def con_mod
    ABILITY_MODS[con]
  end

  def int_mod
    ABILITY_MODS[int]
  end

  def wis_mod
    ABILITY_MODS[wis]
  end

  def cha_mod
    ABILITY_MODS[cha]
  end

  def str_sav
    str_mod
  end

  def dex_sav
    dex_mod
  end

  def con_sav
    con_mod
  end

  def int_sav
    int_mod
  end

  def wis_sav
    wis_mod
  end

  def cha_sav
    cha_mod
  end

  def prof_bonus
    PROFICIENCY_BONUS[level]
  end

  def armor_class
    10 + dex_mod
  end

  def initiative
    dex_mod
  end

  def wis_passive
    10 + wis_mod
  end

  def to_s
    self.class.to_s
  end
end

class Fighter < PlayerRole
  def initialize
    @str = 14
    @dex = 16
    @con = 15
    @int = 11
    @wis = 13
    @cha = 9
    @hit_die = 10
    @current_hp = max_hp
  end

  def max_hp
    10 + con_mod
  end

  def str_sav
    str_mod + prof_bonus
  end

  def con_sav
    con_mod + prof_bonus
  end
end
