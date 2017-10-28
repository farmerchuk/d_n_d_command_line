# player.rb

require_relative 'helpers'

class Player
  include Helpers::Format

  ACTIONS = %w[move examine search alert skill item rest engage]

  attr_accessor :name, :role, :initiative, :area, :location,
                :action, :alert

  def initialize
    @name = nil
    @role = nil
    @initiative = nil
    @area = nil
    @location = nil
    @action = nil
    @alert = false
  end

  def end_turn
    self.action = nil
  end

  def alert!
    self.alert = true
  end

  def alert?
    alert
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
