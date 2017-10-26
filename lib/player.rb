# player.rb

require_relative 'helpers'

class Player
  include Helpers::Format

  ACTIONS = %w[move examine search alert skill item rest engage]

  attr_accessor :name, :hitpoints, :initiative, :area, :location, :action

  def initialize
    @name = nil
    @hitpoints = nil
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

  private

  attr_accessor :alert
  attr_writer :hitpoints
end
