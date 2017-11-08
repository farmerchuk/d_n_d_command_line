# helpers.rb

module Helpers
  module Dice
    def roll_d20
      rand(20) + 1
    end

    def roll_d12
      rand(12) + 1
    end

    def roll_d10
      rand(10) + 1
    end

    def roll_d8
      rand(8) + 1
    end

    def roll_d6
      rand(6) + 1
    end

    def roll_d4
      rand(4) + 1
    end

    def roll_dice(die_as_string)
      rolls, die, operator, adjustment = die_as_string.split(/[d ]/)
      total = 0

      case die
      when '4' then rolls.to_i.times { total += roll_d4 }
      when '6' then rolls.to_i.times { total += roll_d6 }
      when '8' then rolls.to_i.times { total += roll_d8 }
      when '10' then rolls.to_i.times { total += roll_d10 }
      when '12' then rolls.to_i.times { total += roll_d12 }
      when '20' then rolls.to_i.times { total += roll_d20 }
      end

      operator == '+' ? total += adjustment.to_i : total -= adjustment.to_i
    end
  end

  module Data
    def retrieve(id, array)
      selected = array.select { |el| el.id == id }
      selected.first
    end
  end
end
