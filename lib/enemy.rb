# enemy.rb

require_relative 'dnd'

class Enemy
  include Helpers::Dice

  attr_accessor :id, :name, :description, :location, :current_turn,
                :max_hp, :current_hp, :armor_class,
                :melee_attack_bonus, :ranged_attack_bonus,
                :equipped_weapon

  attr_writer   :str_mod, :dex_mod, :con_mod, :int_mod, :wis_mod, :cha_mod

  def initialize
    @id = nil # String
    @name = nil # String
    @description = nil # String
    @location = nil # Location
    @current_turn = false # Boolean
    @max_hp = nil # Integer
    @current_hp = nil # Integer
    @armor_class = nil # Integer
    @str_mod = nil # String
    @dex_mod = nil # String
    @con_mod = nil # String
    @int_mod = nil # String
    @wis_mod = nil # String
    @cha_mod = nil # String
    @melee_attack_bonus = nil # Integer
    @ranged_attack_bonus = nil # Integer
    @equipped_weapon = nil # Weapon
  end

  def str_mod
    @str_mod.to_i
  end

  def dex_mod
    @dex_mod.to_i
  end

  def con_mod
    @con_mod.to_i
  end

  def int_mod
    @int_mod.to_i
  end

  def wis_mod
    @wis_mod.to_i
  end

  def cha_mod
    @cha_mod.to_i
  end

  # attack rolls

  def roll_attack
    weapon_type = equipped_weapon.type

    case weapon_type
    when 'melee' then roll_d20 + melee_attack_bonus
    when 'ranged' then roll_d20 + ranged_attack_bonus
    end
  end

  def roll_weapon_dmg
    roll_dice(equipped_weapon.damage_die)
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

  def initiative
    roll_dex_check
  end

  # other

  def available_paths
    location.paths.select { |path| path.area_id == location.area_id }
  end

  def set_current_turn!
    self.current_turn = true
  end

  def unset_current_turn!
    self.current_turn = false
  end

  def alive?
    current_hp > 0
  end

  def to_s
    name
  end
end
