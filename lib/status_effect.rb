# status_effect.rb

class StatusEffect
  attr_accessor :battle, :long_term

  def initialize
    @battle = StatusBattle.new
    @long_term = StatusLong.new
  end

  def add_battle(attribute, factor)
    battle.augment(attribute, factor)
  end

  def add_long_term(attribute, factor)
    long_term.augment(attribute, factor)
  end

  def clear_all_battle
    battle.clear_all
  end

  def clear_all_long_term
    long_term.clear_all
  end

  def current_hp
    battle.current_hp + long_term.current_hp
  end

  def max_hp
    battle.max_hp + long_term.max_hp
  end
end

class Status
  attr_accessor :current_hp, :max_hp

  def initialize
    @current_hp = 0 # Integer
    @max_hp = 0 # Integer
  end

  def augment(attribute, factor)
    case attribute
    when :current_hp then self.current_hp += factor
    when :max_hp then self.max_hp += factor
    end
  end

  def add(attribute, factor)
    augment(attribute, factor)
  end

  def clear_all
    self.current_hp = 0
    self.max_hp = 0
  end
end

class StatusBattle < Status; end

class StatusLong < Status; end
