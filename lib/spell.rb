# spell.rb

require_relative 'dnd'

class Spell
  include Helpers::Dice

  attr_accessor :id, :level, :save, :display_name, :dice,
                :stat_desc, :general_desc, :roles, :when, :target_type,
                :range, :script

  def self.generate_spells(role)
    spell_data = YAML.load_file('../assets/yaml/spells.yml')
    role_spell_data =
      spell_data.select { |spell| spell['roles'].include?(role) }
    spells = []

    role_spell_data.each do |spell|
      new_spell = Spell.new
      new_spell.id = spell['id']
      new_spell.level = spell['level']
      new_spell.save = spell['save']
      new_spell.display_name = spell['display_name']
      new_spell.dice = spell['dice']
      new_spell.stat_desc = spell['stat_desc']
      new_spell.general_desc = spell['general_desc']
      new_spell.when = spell['when']
      new_spell.target_type = spell['target_type']
      new_spell.range = spell['range']
      new_spell.script = spell['script']
      spells << new_spell
    end

    spells
  end

  def initialize
    @id = nil # String
    @level = nil # Integer
    @save = nil # String
    @display_name = nil # String
    @dice = nil # String
    @stat_desc = nil # String
    @general_desc = nil # String
    @when = nil # String
    @target_type = nil # String
    @range = nil # Integer
    @script = nil # String
  end

  def cast_explore(caster, target, players)
    spell = caster.equipped_spell
    eval(spell.script)
  end

  def cast_battle(caster, target, players, enemies)
    spell = caster.equipped_spell
    eval(spell.script)
  end

  private

  def saving_throw?
    !!save
  end

  def enemy_save?(caster, target)
    difficulty = caster.spell_dc
    saving_throw = target.send("roll_#{save}_check")
    puts "#{target} rolled #{saving_throw} to save " +
         "versus #{caster}'s spell power of #{difficulty}..."
    puts
    saving_throw >= difficulty
  end
end
