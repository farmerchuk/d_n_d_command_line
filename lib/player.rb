# player.rb

require_relative 'dnd'

class Player
  include Helpers::Dice
  include Helpers::Data

  ABILITY_MODS = { 1 => -5, 2 => -4, 3 => -4, 4 => -3, 5 => -3,
                   6 => -2, 7 => -2, 8 => -1, 9 => -1, 10 => 0,
                   11 => 0, 12 => 1, 13 => 1, 14 => 2, 15 => 2,
                   16 => 3, 17 => 3, 18 => 4, 19 => 4, 20 => 5,
                   21 => 5, 22 => 6, 23 => 6, 24 => 7, 25 => 7,
                   26 => 8, 27 => 8, 29 => 9, 30 => 10 }

  PROFICIENCY_BONUS = { 1 => 2, 2 => 2, 3 => 2, 4 => 2,
                        5 => 3, 6 => 3, 7 => 3, 8 => 3,
                        9 => 4, 10 => 4, 11 => 4, 12 => 4,
                        13 => 5, 14 => 5, 15 => 5, 16 => 5,
                        17 => 6, 18 => 6, 19 => 6, 20 => 6 }

  attr_accessor :name, :race, :role,
                :area, :location, :current_turn, :alert, :defending,
                :action, :status_effects, :current_hp,
                :spells, :equipped_spell,
                :backpack, :equipped_accessory,
                :equipped_weapon, :equipped_armor, :equipped_shield

  def initialize
    @name = nil # String
    @race = nil # Race
    @role = nil # Role
    @area = nil # Area
    @location = nil # Location
    @current_turn = false # Boolean
    @alert = false # Boolean
    @defending = false # Boolean
    @action = nil # String
    @status_effects = StatusEffect.new # StatusEffect
    @current_hp = nil # Integer
    @spells = nil # Array of Spell
    @backpack = nil # Backpack
    @equipped_weapon = nil # Weapon
    @equipped_armor = nil # Armor
    @equipped_shield = nil # Armor
    @equipped_accessory = nil # Accessory
    @equipped_spell = nil # Spell
  end

  # proficiency

  def prof_bonus
    PROFICIENCY_BONUS[role.level]
  end

  # attributes

  def str
    race.str + role.str + status_effects.str
  end

  def dex
    race.dex + role.dex + status_effects.dex
  end

  def con
    race.con + role.con + status_effects.con
  end

  def int
    race.int + role.int + status_effects.int
  end

  def wis
    race.wis + role.wis + status_effects.wis
  end

  def cha
    race.cha + role.cha + status_effects.cha
  end

  # attribute modifiers

  def str_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('str')
    ABILITY_MODS[str] + bonus
  end

  def dex_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('dex')
    ABILITY_MODS[dex] + bonus
  end

  def con_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('con')
    ABILITY_MODS[con] + bonus
  end

  def int_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('int')
    ABILITY_MODS[int] + bonus
  end

  def wis_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('wis')
    ABILITY_MODS[wis] + bonus
  end

  def cha_mod
    bonus = 0
    bonus = prof_bonus if role.proficiency.include?('cha')
    ABILITY_MODS[cha] + bonus
  end

  # checks (challenges and saving throws)

  def roll_str_check
    roll_d20 + str_mod
  end

  def roll_dex_check
    roll_d20 + dex_mod
  end

  def roll_con_check
    roll_d20 + con_mod
  end

  def roll_wis_check
    roll_d20 + wis_mod
  end

  def roll_cha_check
    roll_d20 + cha_mod
  end

  def initiative
    roll_dex_check + status_effects.initiative
  end

  # passive checks

  def wis_passive
    10 + wis_mod
  end

  # other stats

  def max_hp
    role.hit_die + con_mod + status_effects.max_hp
  end

  def armor_class
    ac_of_equipment + ac_dex_bonus + status_effects.armor_class
  end

  def ac_of_equipment
    armor = equipped_armor ? equipped_armor.armor_class : 10
    shield = equipped_shield ? equipped_shield.armor_class : 0
    armor + shield
  end

  def ac_dex_bonus
    if equipped_armor.dex_bonus_max == nil
      dex_mod
    else
      equipped_armor.dex_bonus_max
    end
  end

  def roll_attack
    weapon_type = equipped_weapon.type

    case weapon_type
    when 'melee' then roll_d20 + str_mod
    when 'ranged' then roll_d20 + dex_mod
    end
  end

  def roll_weapon_dmg
    roll_dice(equipped_weapon.damage_die)
  end

  def caster
    role.caster
  end

  def spend_cast
    role.casts_remaining -= 1
  end

  def casts_remaining
    role.casts_remaining
  end

  def casts_max
    role.casts_max
  end

  def reset_casts_remaining
    role.casts_remaining = casts_max
  end

  def casts_exhausted?
    casts_remaining <= 0
  end

  def spell_dc
    case role.to_s
    when 'wizard' then 8 + int_mod
    when 'cleric' then 8 + wis_mod
    else
      nil
    end
  end

  # actions

  def available_paths
    location.paths.select { |path| path.unlocked? }
  end

  def available_paths_during_battle
    available_paths.select { |path| path.area_id == area.id }
  end

  def start_turn
    clear_all_turn_status_effects
    self.alert = false
    self.defending = false
  end

  def end_action
    self.action = nil
    self.equipped_spell = nil
  end

  def use_item(item)
    # code
  end

  # other methods

  def conditions
    status_effects.conditions
  end

  def cond_acronym
    status_effects.cond_acronym
  end

  def add_condition(condition)
    status_effects.add_condition(condition)
  end

  def clear_condition(condition)
    status_effects.clear_condition(condition)
  end

  def add_turn_status_effect(attribute, factor)
    status_effects.add_turn(attribute, factor)
  end

  def add_battle_status_effect(attribute, factor)
    status_effects.add_battle(attribute, factor)
  end

  def add_long_term_status_effect(attribute, factor)
    status_effects.add_long_term(attribute, factor)
  end

  def add_permanent_status_effect(attribute, factor)
    status_effects.add_permanent(attribute, factor)
  end

  def clear_all_turn_status_effects
    status_effects.clear_all_turn
  end

  def clear_all_battle_status_effects
    status_effects.clear_all_battle
  end

  def clear_all_long_term_status_effects
    status_effects.clear_all_long_term
  end

  def clear_all_permanent_status_effects
    status_effects.clear_all_permanent
  end

  def clear_permanent_status_effect(attribute)
    status_effects.clear_permanent(attribute)
  end

  def clear_all_temp_status_effects
    clear_all_turn_status_effects
    clear_all_battle_status_effects
    clear_all_long_term_status_effects
  end

  def set_current_hp_to_max
    self.current_hp = max_hp
  end

  def set_current_turn!
    self.current_turn = true
  end

  def unset_current_turn!
    self.current_turn = false
  end

  def equip(equipment_id)
    item = retrieve(equipment_id, backpack.all_unequipped_equipment)
    raise StandardError, 'No equipment matching id' if item.nil?

    item.checkout_equipment_by(self)

    if item.instance_of?(Weapon)
      self.equipped_weapon = item
    elsif item.instance_of?(Armor) && item.type == 'shield'
      self.equipped_shield = item
    elsif item.instance_of?(Armor)
      self.equipped_armor = item
    elsif item.instance_of?(Accessory)
      self.equipped_accessory = item
    end

    eval item.equip_script if item.equip_script
  end

  def unequip(equipment)
    if equipment
      equipment.checkin_equipment
      eval equipment.unequip_script if equipment.unequip_script
    end
  end

  def all_equipped
    [equipped_weapon, equipped_armor, equipped_shield, equipped_accessory].compact
  end

  def hidden?
    status_effects.conditions.include?('hidden')
  end

  def alive?
    current_hp > 0
  end

  def dead?
    current_hp <= 0
  end

  def to_s
    name
  end

  def view
    Menu.clear_screen

    puts "PLAYER PROFILE:"
    Menu.draw_line
    puts

    puts "GENERAL".ljust(52) +
      Menu.margin_inner +
      "CONDITION".ljust(52)
    puts Menu.half_line +
      Menu.margin_inner +
      Menu.half_line
    puts "NAME:  #{name.ljust(50)}" +
      "HIT POINTS:   #{current_hp} / #{max_hp}"
    puts "ROLE:  #{role.to_s.capitalize.ljust(50)}" +
      "SPELL CASTS:  #{casts_remaining} / #{casts_max}"
    puts "RACE:  #{race.to_s.ljust(50)}" +
      "CONDITIONS:   #{cond_acronym.join(' ')}"
    puts
    puts

    puts "ABILITY SCORES".ljust(52) +
      Menu.margin_inner +
      "ABILITY ROLL MODIFIERS".ljust(52)
    puts Menu.half_line +
      Menu.margin_inner +
      Menu.half_line

    puts "STRENGTH:      #{str.to_s.ljust(10)}DEXTERITY:     #{dex.to_s}".ljust(56) +
      "STRENGTH:      #{str_mod.to_s.ljust(10)}DEXTERITY:     #{dex_mod.to_s}"
    puts "CONSTITUTION:  #{con.to_s.ljust(10)}INTELLIGENCE:  #{int.to_s}".ljust(56) +
      "CONSTITUTION:  #{con_mod.to_s.ljust(10)}INTELLIGENCE:  #{int_mod.to_s}"
    puts "WISDOM:        #{wis.to_s.ljust(10)}CHARISMA:      #{cha.to_s}".ljust(56) +
      "WISDOM:        #{wis_mod.to_s.ljust(10)}CHARISMA:      #{cha_mod.to_s}"
    puts
    puts Menu.half_line_spacer +
      "PROFICIENCY BONUS:  " +
      "+#{prof_bonus} (#{role.proficiency[0].upcase} & " +
      "#{role.proficiency[1].upcase})"
    puts
    puts
    puts 'EQUIPPED WEAPON'
    Menu.draw_line
    puts 'NAME                     TYPE           DAMAGE         SPECIAL EFFECTS'
    puts
    puts "#{equipped_weapon.display_in_profile}" if equipped_weapon
    puts
    puts
    puts "EQUIPPED ARMOR                          ARMOR CLASS TOTAL: #{armor_class}"
    Menu.draw_line
    puts 'NAME                     TYPE           ARMOR CLASS    SPECIAL EFFECTS'
    puts
    puts "#{equipped_armor.display_in_profile}" if equipped_armor
    puts "#{equipped_shield.display_in_profile}" if equipped_shield
    puts
    puts
    puts 'EQUIPPED ACCESSORY'
    Menu.draw_line
    puts 'NAME                     TYPE           SPECIAL EFFECTS'
    puts
    puts "#{equipped_accessory.display_in_profile}" if equipped_accessory
    puts
  end
end
