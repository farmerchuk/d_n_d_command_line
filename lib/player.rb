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

  def select_first_action
    puts 'What action would the player like to take?'
    puts "0. move"
    puts "1. other action"

    choice = choose([0, 1])
    puts
    choice == 0 ? self.action = 'move' : nil
  end

  def select_action
    puts 'What action would the player like to take?'
    ACTIONS.each_with_index { |opt, idx| puts "#{idx}. #{opt}" }

    choice = choose(0..(ACTIONS.size - 1))
    puts
    self.action = ACTIONS[choice]
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
