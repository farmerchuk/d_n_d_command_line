# player.rb

require_relative 'helpers'

class Player
  include Helpers::Format

  ACTIONS = [:move, :examine, :search, :alert, :skill, :item, :rest, :engage]

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

  def select_action # => nil
    puts 'What action would the player like to take?'
    ACTIONS.each_with_index { |opt, idx| puts "#{idx}. #{opt}" }
    choice = nil
    loop do
      choice = prompt.to_i
      break if (0..(ACTIONS.size - 1)).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end
    puts
    self.action = ACTIONS[choice]
    nil
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
