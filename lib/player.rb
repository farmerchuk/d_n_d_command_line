# player.rb

class Player
  attr_reader :name, :hitpoints
  attr_accessor :location, :action

  def initialize(name, hitpoints, location)
    @name = name
    @hitpoints = hitpoints
    @action = nil
    @location = location
    @alert = false
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

  private

  attr_accessor :alert
  attr_writer :hitpoints
end

player1 = Player.new('Jason', 10, :area1)
p player1.name
p player1.location
p player1.action
p player1.alert?
p player1.alert!
p player1.alert?
p player1.rest!
p player1.hitpoints
