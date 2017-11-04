# battle.rb

class Battle
  attr_accessor :id, :description, :enemy_ids

  def initialize
    @id = nil # String
    @description = nil # String
    @enemy_ids = nil # Array
    @enemies = nil # Array of Enemy
  end

  private

  def build_enemies
    enemy_info = YAML.load_data('../assets/yaml/enemies.yml')

  end
end
