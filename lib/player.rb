# player.rb

require_relative 'helpers'

class Player
  include Helpers::Format

  ACTIONS = %w[move examine search wait skill item rest engage]

  attr_accessor :name, :role, :alignment,
                :area, :location,
                :action, :wait

  def initialize
    @name = nil
    @role = nil
    @alignment = nil
    @area = nil
    @location = nil
    @action = nil
    @wait = false
  end

  def end_turn
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

  def to_s
    name
  end
end
