# status_effect.rb

class StatusEffect
  CONDITION_ACRONYMS = {
    'blinded' => 'BLD',
    'unconscious' => 'UNC',
    'paralyzed' => 'PAR',
    'invisible' => 'INV',
    'poisoned' => 'PSN',
    'hidden' => 'HID'
  }

  attr_accessor :turn, :battle, :long_term, :permanent, :conditions

  def initialize
    @turn = StatusTurn.new
    @battle = StatusBattle.new
    @long_term = StatusLong.new
    @permanent = StatusPermanent.new
    @conditions = [] # Array of String
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

  def add_permanent(attribute, factor)
    permanent.add(attribute, factor)
  end

  def add_condition(condition)
    case condition
    when 'blinded' then conditions << 'blinded'
    when 'unconscious' then conditions << 'unconscious'
    when 'paralyzed' then conditions << 'paralyzed'
    when 'invisible' then conditions << 'invisible'
    when 'poisoned' then conditions << 'poisoned'
    when 'hidden' then conditions << 'hidden'
    end
  end

  def cond_acronym
    return ['NONE'] if conditions.empty?
    conditions.map { |condition| CONDITION_ACRONYMS[condition] }
  end

  def clear_condition(condition)
    conditions.reject! { |cond| cond == condition }
  end

  def clear_all_conditions
    conditions.clear
  end

  def clear_all_turn
    turn.clear_all
  end

  def clear_all_battle
    battle.clear_all
    clear_all_conditions
  end

  def clear_all_long_term
    long_term.clear_all
  end

  def clear_all_permanent
    permanent.clear_all
  end

  def clear_permanent(attribute)
    permanent.clear(attribute)
  end

  def max_hp
    turn.max_hp + battle.max_hp + long_term.max_hp + permanent.max_hp
  end

  def armor_class
    turn.armor_class + battle.armor_class + long_term.armor_class + permanent.armor_class
  end

  def initiative
    turn.initiative + battle.initiative + long_term.initiative + permanent.initiative
  end

  def str
    turn.str + battle.str + long_term.str + permanent.str
  end

  def dex
    turn.dex + battle.dex + long_term.dex + permanent.dex
  end

  def con
    turn.con + battle.con + long_term.con + permanent.con
  end

  def int
    turn.int + battle.int + long_term.int + permanent.int
  end

  def wis
    turn.wis + battle.wis + long_term.wis + permanent.wis
  end

  def cha
    turn.cha + battle.cha + long_term.cha + permanent.cha
  end
end

class Status
  attr_accessor :max_hp, :armor_class, :initiative,
                :str, :dex, :con, :int, :wis, :cha

  def initialize
    @max_hp = 0 # Integer
    @armor_class = 0 # Integer
    @initiative = 0 # Integer
    @str = 0 # Integer
    @dex = 0 # Integer
    @con = 0 # Integer
    @int = 0 # Integer
    @wis = 0 # Integer
    @cha = 0 # Integer
  end

  def add(attribute, factor)
    case attribute
    when :max_hp then self.max_hp += factor
    when :armor_class then self.armor_class += factor
    when :initiative then self.initiative += factor
    when :str then self.str += factor
    when :dex then self.dex += factor
    when :con then self.con += factor
    when :int then self.int += factor
    when :wis then self.wis += factor
    when :cha then self.cha += factor
    end
  end

  def clear(attribute)
    case attribute
    when :max_hp then self.max_hp = 0
    when :armor_class then self.armor_class = 0
    when :initiative then self.initiative = 0
    when :str then self.str = 0
    when :dex then self.dex = 0
    when :con then self.con = 0
    when :int then self.int = 0
    when :wis then self.wis = 0
    when :cha then self.cha = 0
    end
  end

  def clear_all
    self.max_hp = 0
    self.armor_class = 0
    self.initiative = 0
    self.str = 0
    self.dex = 0
    self.con = 0
    self.int = 0
    self.wis = 0
    self.cha = 0
  end
end

class StatusTurn < Status; end

class StatusBattle < Status; end

class StatusLong < Status; end

class StatusPermanent < Status; end
