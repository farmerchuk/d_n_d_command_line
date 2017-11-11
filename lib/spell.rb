# spell.rb

require_relative 'dnd'

class Spell
  attr_accessor :id, :level, :display_name, :stat_desc, :general_desc,
                :roles, :when, :target, :range, :aoe, :script

  def self.generate_spells(role)
    spell_data = YAML.load_file('../assets/yaml/spells.yml')
    role_spell_data =
      spell_data.select { |spell| spell['roles'].include?(role) }
    spells = []

    role_spell_data.each do |spell|
      new_spell = Spell.new
      new_spell.id = spell['id']
      new_spell.level = spell['level']
      new_spell.display_name = spell['display_name']
      new_spell.stat_desc = spell['stat_desc']
      new_spell.general_desc = spell['general_desc']
      new_spell.when = spell['when']
      new_spell.target = spell['target']
      new_spell.range = spell['range']
      new_spell.aoe = spell['aoe']
      new_spell.script = spell['script']
      spells << new_spell
    end

    spells
  end

  def initialize
    @id = nil # String
    @level = nil # Integer
    @display_name = nil # String
    @stat_desc = nil # String
    @general_desc = nil # String
    @when = nil # String
    @target = nil # String
    @range = nil # Integer
    @aoe = nil # String
    @script = nil # String
  end
end
