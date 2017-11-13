# spell.rb

require_relative 'dnd'

class Spell
  include Helpers::Dice

  attr_accessor :id, :level, :save, :display_name, :dice, :effect,
                :stat_desc, :general_desc, :roles, :when, :target_type,
                :range, :aoe, :script

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
      new_spell.effect = spell['effect']
      new_spell.stat_desc = spell['stat_desc']
      new_spell.general_desc = spell['general_desc']
      new_spell.when = spell['when']
      new_spell.target_type = spell['target_type']
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
    @save = nil # String
    @display_name = nil # String
    @dice = nil # String
    @effect = nil # String
    @stat_desc = nil # String
    @general_desc = nil # String
    @when = nil # String
    @target_type = nil # String
    @range = nil # Integer
    @aoe = nil # String
    @script = nil # String
  end

  def cast(caster, target, players, enemies = nil)
    puts general_desc
    puts
    if enemies
      cast_battle_spell(caster, target, players, enemies)
    else
      cast_explore_spell(caster, target, players)
    end
  end

  private

  def saving_throw?
    !!save
  end

  def cast_battle_spell(caster, target, players, enemies)
    if aoe == 'single' && target_type == 'enemy'
      saved = enemy_save?(caster, target) if saving_throw?
      damage = roll_dice(dice)
      damage /= 2 if saved
      target.current_hp -= damage

      if saved
        puts "#{target} saved against #{caster}'s' spell!"
        puts
        puts "You hit the #{target} and dealt #{damage} damage."
      else
        puts "#{target}'s save against #{caster}'s spell failed!"
        puts
        puts "You hit the #{target} at full power and dealt #{damage} damage."
      end
    elsif aoe == 'single' && target_type == 'player'
      hp = roll_dice(dice)
      target.current_hp += hp
      
      if target.current_hp > target.max_hp
        target.current_hp = target.max_hp
      end

      puts "#{caster} heals #{target} by #{hp} HPs."
    elsif aoe == 'all' && target_type == 'enemy'

    elsif aoe == 'all' && target_type == 'player'

    else
      puts "Spell fizzled out..."
    end
  end

  def cast_explore_spell(caster, target, players)

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
