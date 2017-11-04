# battle.rb

class Battle
  attr_accessor :id, :description, :enemy_ids

  def initialize
    @id = nil # String
    @description = nil # String
    @enemy_ids = nil # Array
  end
end
