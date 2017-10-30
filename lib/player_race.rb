# player_race.rb

class PlayerRace
  RACES = %w[human dwarf elf half-elf halfling gnome]

  attr_reader :str, :dex, :con, :int, :wis, :cha

  def to_s
    self.class.to_s
  end
end

class Human < PlayerRace
  def initialize
    @str = 1
    @dex = 1
    @con = 1
    @int = 1
    @wis = 1
    @cha = 1
  end
end

class Dwarf < PlayerRace
  def initialize
    @str = 0
    @dex = 0
    @con = 2
    @int = 0
    @wis = 0
    @cha = 0
  end
end

class Elf < PlayerRace
  def initialize
    @str = 0
    @dex = 2
    @con = 0
    @int = 0
    @wis = 0
    @cha = 0
  end
end

class HalfElf < PlayerRace
  def initialize
    @str = 0
    @dex = 1
    @con = 0
    @int = 1
    @wis = 0
    @cha = 2
  end
end

class Halfling < PlayerRace
  def initialize
    @str = 0
    @dex = 2
    @con = 0
    @int = 0
    @wis = 0
    @cha = 0
  end
end

class Gnome < PlayerRace
  def initialize
    @str = 0
    @dex = 0
    @con = 0
    @int = 2
    @wis = 0
    @cha = 0
  end
end
