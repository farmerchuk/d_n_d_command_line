# coin_purse.rb

require_relative 'helpers'

class CoinPurse
  include Helpers::Format

  attr_accessor :gold

  def initialize(int)
    @gold = int
  end

  def add_gold(int)
    self.gold += int.to_i
  end

  def sub_gold(int)
    raise ArgumentError if gold - int < 0
    self.gold -= int.to_i
  end

  def balance
    num_with_commas(gold)
  end
end
