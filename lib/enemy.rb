# enemy.rb

require_relative 'helpers'

class Enemy
  include Helpers::DICE

  attr_accessor :id, :name, :location, :max_hp, :current_hp, :armor_class,
                :str_mod, :dex_mod, :con_mod, :int_mod, :wis_mod, :cha_mod,
                :melee_attack_bonus, :ranged_attack_bonus

  def initialize
    @id = nil # String
    @name = nil # String
    @location = nil # Location
    @max_hp = nil # Integer
    @current_hp = nil # Integer
    @armor_class = nil # Integer
    @str_mod = nil # Integer
    @dex_mod = nil # Integer
    @con_mod = nil # Integer
    @int_mod = nil # Integer
    @wis_mod = nil # Integer
    @cha_mod = nil # Integer
    @melee_attack_bonus = nil # String
    @ranged_attack_bonus = nil # String
  end

  # attack rolls

  def roll_melee_attack
    roll_d20 + melee_attack_bonus
  end

  def roll_ranged_attack
    roll_d20 + ranged_attack_bonus
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
end
