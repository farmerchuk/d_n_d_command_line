# player.rb

require_relative 'helpers'
require_relative 'coin_purse'

class Player
  include Helpers::Dice

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

  ACTIONS = %w[move examine search wait skill item rest engage]

  attr_accessor :name, :race, :role, :alignment,
                :area, :location,
                :action, :wait,
                :current_hp,
                :purse

  def initialize(purse, backpack)
    @name = nil
    @race = nil
    @role = nil
    @alignment = nil
    @area = nil
    @location = nil
    @action = nil
    @wait = false
    @current_hp = nil
    @purse = purse
    @backpack = backpack
  end

  # proficiency

  def prof_bonus
    PROFICIENCY_BONUS[role.level]
  end

  # attributes

  def str
    race.str + role.str
  end

  def dex
    race.dex + role.dex
  end

  def con
    race.con + role.con
  end

  def int
    race.int + role.int
  end

  def wis
    race.wis + role.wis
  end

  def cha
    race.cha + role.cha
  end

  # attribute modifiers

  def str_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('str')
    ABILITY_MODS[str] + bonus
  end

  def dex_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('dex')
    ABILITY_MODS[dex] + bonus
  end

  def con_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('con')
    ABILITY_MODS[con] + bonus
  end

  def int_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('int')
    ABILITY_MODS[int] + bonus
  end

  def wis_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('wis')
    ABILITY_MODS[wis] + bonus
  end

  def cha_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('cha')
    ABILITY_MODS[cha] + bonus
  end

  # checks (challenges and saving throws)

  def roll_str_check
    roll_d20 + str_mod
  end

  def roll_dex_check
    roll_d20 + dex_mod
  end

  def roll_con_check
    roll_d20 + con_mod
  end

  def roll_wis_check
    roll_d20 + wis_mod
  end

  def roll_cha_check
    roll_d20 + cha_mod
  end

  # passive checks

  def wis_passive
    10 + wis_mod
  end

  # other stats

  def max_hp
    lv_1_hp = role.hit_die + con_mod
    lv_x_hp = (role.hit_die / 2 + 1 + con_mod) * (role.level - 1)
    lv_1_hp + lv_x_hp
  end

  def armor_class
    10 + dex_mod
  end

  def initiative
    dex_mod
  end

  def roll_attack(weapon)
    weapon_type = weapon.type

    case weapon_type
    when 'melee' then roll_d20 + str_mod
    when 'ranged' then roll_d20 + dex_mod
    end
  end

  # actions

  def start_turn
    self.wait = false
  end

  def end_action
    self.action = nil
  end

  def wait!
    self.wait = true
  end

  def wait?
    wait
  end

  def use_skill(skill)
    # code
  end

  def use_item(item)
    # code
  end

  def rest!

  end

  # other methods

  def set_current_hp_to_max
    self.current_hp = max_hp
  end

  def to_s
    name
  end
end
