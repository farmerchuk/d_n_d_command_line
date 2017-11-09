# action_handler.rb

require_relative 'dnd'

class ActionHandler
  attr_accessor :players, :current_player, :locations

  def initialize(players, locations)
    @players = players
    @current_player = players.current
    @locations = locations
  end

  def player_choose_first_action
    puts "What action would #{current_player.name} like to take first?"
    choice = Menu.choose_from_menu(['move', 'other action'])
    choice == 'move' ? current_player.action = 'move' : nil
  end

  def player_also_move?
    puts "Would #{current_player.name} also like to move?"
    choice = Menu.choose_from_menu(['yes', 'no'])
    choice == 'yes' ? true : false
  end

  def player_move
    puts "Where would #{current_player.name} like to move to?"
    available_locations = current_player.location.paths
    current_player.location = Menu.choose_from_menu(available_locations)

    puts "#{current_player} is now at the #{current_player.location.display_name}"
    puts
  end

  def player_wait
    puts "#{current_player} is on alert!"
    puts
  end

  def player_use_skill
    puts "#{current_player} uses a skill."
    puts
  end

  def player_use_item
    puts "#{current_player} uses an item."
    puts
  end

  def player_rest
    puts "#{current_player} rests."
    puts
  end

  def player_equip
    available_equipment = current_player.backpack.all_unequipped_equipment

    if available_equipment.empty?
      puts 'Sorry, all equipment is currently in use...'
    else
      current_player.backpack.view_equippable

      puts "Select the item to equip:"
      choice = Menu.choose_from_menu(available_equipment)

      if choice.instance_of?(Weapon)
        current_player.unequip(current_player.equipped_weapon)
      elsif choice.instance_of?(Armor) && choice.type == 'shield'
        current_player.unequip(current_player.equipped_shield)
      elsif choice.instance_of?(Armor)
        current_player.unequip(current_player.equipped_armor)
      end

      current_player.equip(choice.id)
    end
  end
end

class ExploreActionHandler < ActionHandler
  ACTIONS = %w[move examine search wait skill item equip rest engage]

  attr_accessor :events, :event, :script

  def initialize(players, locations, events)
    super(players, locations)
    @events = events
    @event = nil
    @script = nil
  end

  def run
    display_summary
    current_player.start_turn
    player_choose_first_action

    if current_player.action == 'move'
      run_action
      player_selects_action
      run_action
    else
      player_selects_action
      run_action
      current_player.action = 'move' if player_also_move?
      run_action
    end
    Menu.prompt_for_next_turn
  end

  def run_action
    display_summary
    set_event
    set_script
    resolve_player_action
    reset_event
    current_player.end_action
    Menu.prompt_continue
    display_summary
  end

  def player_selects_action
    puts "What action would #{current_player.name} like to take?"
    current_player.action = Menu.choose_from_menu(ACTIONS)
  end

  def execute_player_action
    case current_player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
    end
  end

  def resolve_player_action
    execute_player_action
    execute_event_description
    execute_event_script
  end

  def set_event
    return unless events
    events.each do |evt|
      if evt.trigger == current_player.action &&
         evt.location == current_player.location
        self.event = evt
      end
    end
  end

  def set_script
    self.script = event && event.script ? event.script : nil
  end

  def execute_event_description
    if event
      puts event.description
    else
      puts 'Nothing happens...' unless current_player.action == 'equip'
    end
  end

  def execute_event_script
    eval(script) if script
  end

  def reset_event
    self.event = nil
    self.script = nil
  end

  def display_summary
    self.class.display_summary(players)
  end

  def self.display_summary(players)
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS:'
    Menu.draw_line
    players.each do |player|
      puts "#{player.to_s.ljust(12)}" +
           "(#{player.race} #{player.role} / #{player.current_hp} HP)".ljust(28) +
           "is at the #{player.location.display_name}".ljust(33) +
           (player.current_turn ? "<< Current Player" : "")
    end
    puts
    puts
    puts "CURRENT PLAYER LOCATION: #{players.current.location.display_name}"
    Menu.draw_line
    puts players.current.location.description
    puts
    puts
    puts 'EXPLORATION DETAILS:'
    Menu.draw_line
    puts
  end
end

class BattleActionHandler < ActionHandler
  ACTIONS = %w[move attack wait skill item equip]

  attr_accessor :enemies, :all_entities

  def initialize(players, locations, enemies, all_entities)
    super(players, locations)
    @enemies = enemies
    @all_entities = all_entities
  end

  def run
    display_summary
    current_player.start_turn
    player_choose_first_action

    if current_player.action == 'move'
      run_action
      player_selects_action
      run_action
    else
      player_selects_action
      run_action
      current_player.action = 'move' if player_also_move?
      run_action
    end
    Menu.prompt_for_next_turn
  end

  def run_action
    display_summary
    execute_player_action
    current_player.end_action
    Menu.prompt_continue
    display_summary
  end

  def player_selects_action
    puts "What action would #{current_player.name} like to take?"
    current_player.action = Menu.choose_from_menu(ACTIONS)
  end

  def execute_player_action
    case current_player.action
    when 'move' then player_move
    when 'wait' then player_wait
    when 'skill' then player_use_skill
    when 'item' then player_use_item
    when 'rest' then player_rest
    when 'equip' then player_equip
    when 'attack' then player_attack
    end
  end

  def player_attack
    # player selects enemy to attack (show their locations in list)
    # player misses if enemy is not in range of equipped weapon
    # calculate attack
    # compare to enemy AC
    # if successful calculate damage
    # update enemy current hitpoints
    # display result message
    # prompt for next player
  end

  def display_summary
    self.class.display_summary(all_entities)
  end

  def self.display_summary(all_entities)
    Menu.clear_screen
    puts 'BATTLE TURN ORDER & DETAILS:'
    Menu.draw_line
    all_entities.each do |entity|
      if entity.instance_of?(Player)
        puts "#{entity.to_s.ljust(12)}" +
             "(#{entity.race} #{entity.role} / #{entity.current_hp} HP)".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33) +
             (entity.current_turn ? "<< Current Player" : "")
      elsif entity.instance_of?(Enemy)
        puts "#{entity.to_s.ljust(12)}" +
             "(Monster / #{entity.current_hp} HP)".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33) +
             (entity.current_turn ? "<< Current Player" : "")
      end
    end
    puts
    puts
    puts 'BATTLE DETAILS:'
    Menu.draw_line
    puts
  end
end
