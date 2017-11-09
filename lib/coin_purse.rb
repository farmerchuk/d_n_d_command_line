# coin_purse.rb

require_relative 'dnd'

class CoinPurse
  attr_accessor :gold

  def initialize(int)
    @gold = int
  end

  def +(int)
    self.gold += int
  end

  def -(int)
    raise ArgumentError if gold - int < 0
    self.gold -= int
  end

  def to_s
    Menu.num_with_commas(gold)
  end
end
