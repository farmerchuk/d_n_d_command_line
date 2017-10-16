# player.rb

class Player
  ACTIONS = [:move, :examine, :search, :alert, :skill, :item, :rest, :engage]

  attr_reader :name, :hitpoints
  attr_accessor :point_of_interest, :action

  def initialize(name, hitpoints, point_of_interest)
    @name = name
    @hitpoints = hitpoints
    @action = nil
    @point_of_interest = point_of_interest
    @alert = false
  end

  def choose_action # => nil
    puts 'Please select an action:'
    ACTIONS.each_with_index { |opt, idx| puts "#{idx}. #{opt}" }
    choice = nil
    loop do
      choice = gets.chomp.to_i
      break if (0..(ACTIONS.size - 1)).include?(choice)
      puts 'Sorry, that is not a valid choice...'
    end
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
    self.hitpoints += 2
  end

  def to_s
    name
  end

  private

  attr_accessor :alert
  attr_writer :hitpoints
end
