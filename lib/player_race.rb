# player_race.rb

class PlayerRace
  RACES = %w[human]

  def to_s
    self.class.to_s
  end
end

class Human < PlayerRace
  attr_reader :str, :dex, :con, :int, :wis, :cha

  def initialize
    @str = 1
    @dex = 1
    @con = 1
    @int = 1
    @wis = 1
    @cha = 1
  end
end
