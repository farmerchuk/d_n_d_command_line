# battle.rb

require_relative 'dnd'

class Battle
  include Helpers::Data

  attr_accessor :id, :locations,
                :enemy_and_location_ids, :enemies

  def initialize(locations)
    @id = nil # String
    @locations = locations
    @enemy_and_location_ids = nil # Array of String
    @enemies = [] # Array of Enemy
  end

  def build_enemies
    enemy_data = YAML.load_file('../assets/yaml/enemies.yml')

    enemy_and_location_ids.each do |enemy_and_location_id|
      enemy_id = enemy_and_location_id.split.first
      enemy_location_id = enemy_and_location_id.split.last

      enemy_data.each do |enemy|
        if enemy['id'] == enemy_id
          new_enemy = Enemy.new
          new_enemy.id = enemy_id
          new_enemy.name = enemy['name']
          new_enemy.description = enemy['description']
          new_enemy.location = get_enemy_location(enemy_location_id)
          new_enemy.max_hp = enemy['max_hp']
          new_enemy.current_hp = enemy['current_hp']
          new_enemy.armor_class = enemy['armor_class']
          new_enemy.str_mod = enemy['str_mod']
          new_enemy.dex_mod = enemy['dex_mod']
          new_enemy.con_mod = enemy['con_mod']
          new_enemy.int_mod = enemy['int_mod']
          new_enemy.wis_mod = enemy['wis_mod']
          new_enemy.cha_mod = enemy['cha_mod']
          new_enemy.melee_attack_bonus = enemy['melee_attack_bonus']
          new_enemy.ranged_attack_bonus = enemy['ranged_attack_bonus']
          new_enemy.equipped_weapon =
            Equipment.build_weapon(enemy['equipped_weapon'])
          enemies << new_enemy
        end
      end
    end
  end

  private

  def get_enemy_location(enemy_location_id)
    retrieve(enemy_location_id, locations)
  end
end
