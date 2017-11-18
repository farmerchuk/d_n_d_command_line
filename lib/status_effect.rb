# status_effect.rb

class StatusEffect
  attr_accessor :turn, :battle, :long_term

  def initialize
    @turn = StatusTurn.new
    @battle = StatusBattle.new
    @long_term = StatusLong.new
  end

  def add_turn(attribute, factor)
    turn.add(attribute, factor)
  end

  def add_battle(attribute, factor)
    battle.add(attribute, factor)
  end

  def add_long_term(attribute, factor)
    long_term.add(attribute, factor)
  end

  def clear_all_turn
    turn.clear_all
  end

  def clear_all_battle
    battle.clear_all
  end

  def clear_all_long_term
    long_term.clear_all
  end

  def max_hp
    turn.max_hp + battle.max_hp + long_term.max_hp
  end

  def armor_class
    turn.armor_class + battle.armor_class + long_term.armor_class
  end
end

class Status
  attr_accessor :max_hp, :armor_class

  def initialize
    @max_hp = 0 # Integer
    @armor_class = 0 # Integer
  end

  def add(attribute, factor)
    case attribute
    when :max_hp then self.max_hp += factor
    when :armor_class then self.armor_class += factor
    end
  end

  def clear_all
    self.max_hp = 0
    self.armor_class = 0
  end
end

class StatusTurn < Status; end

class StatusBattle < Status; end

class StatusLong < Status; end
