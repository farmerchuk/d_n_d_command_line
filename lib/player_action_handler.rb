# player_action_handler.rb

require_relative 'dnd'

class PlayerActionHandler
  include Helpers::Data

  attr_accessor :players, :current_player, :locations, :areas,
                :events, :event, :script, :action_success

  def initialize(players, locations, areas)
    @players = players
    @current_player = players.current
    @locations = locations
    @areas = areas
    @events = []
    @event = nil
    @script = nil
    @action_success = true
  end

  def build_events
    event_data = YAML.load_file('../assets/yaml/events.yml')

    event_data.each do |event|
      new_event = Event.new
      new_event.id = event['id']
      new_event.location_id = event['location_id']
      new_event.description = event['description']
      new_event.trigger = event['trigger']
      new_event.script = event['script']
      events << new_event
    end

    add_location_to_events
  end

  def add_location_to_events
    events.each do |event|
      locations.each do |location|
        if event.location_id == location.id
          event.location = location
        end
      end
    end
  end

  def run
    build_events
    display_summary
    current_player.start_turn
    run_actions
    display_summary
    Menu.prompt_end_player_turn
  end

  def action_fail
    self.action_success = false
  end

  def end_action
    current_player.end_action
    self.action_success = true
  end

  def run_actions
    2.times do |n|
      display_summary
      cycle_action(n)
      Menu.prompt_continue
    end
  end

  def cycle_action(n)
    loop do
      player_selects_action(n)
      execute_player_action
      break if action_success
      end_action
      Menu.prompt_continue
      display_summary
    end
    end_action
  end

  def player_selects_action(n)
    puts "What action would #{current_player.name} like to take? " +
         "(Action #{n + 1} of 2)"

    role = current_player.role.to_s
    options = eval("#{role.capitalize}::#{action_type.upcase}_ACTIONS")
    current_player.action =
      Menu.choose_from_menu(options) do
        options.each_with_index do |el, idx|
          if el == 'magic'
            casts = current_player.casts_remaining
            puts "#{idx}. #{el} (#{casts} cast#{'s' if casts > 1} remaining)"
          else
            puts "#{idx}. #{el}"
          end
        end
      end
  end

  def execute_player_action
    execute_non_move_no_event
    execute_move
    execute_event
  end

  def execute_non_move_no_event
    if !event && current_player.action != 'move'
      display_summary
      execute_chosen_action
    end
  end

  def execute_move
    if current_player.action == 'move'
      display_summary
      player_move
      MainMenuHandler.display_area_introduction(current_player.area)
    end
  end

  def execute_event
    set_event
    if event
      display_summary
      display_event_description
      eval(script) if script
      end_event
    end
  end

  def execute_chosen_action
    case current_player.action
    when 'examine' then player_examine
    when 'search' then player_search
    when 'wait' then player_wait
    when 'item' then player_use_item
    when 'equip' then player_equip
    when 'attack' then player_attack
    when 'talk' then player_talk
    when 'magic' then player_magic
    when 'hide' then player_hide
    end
  end

  def set_event
    new_event = nil
    events.each do |evt|
      if evt.trigger == current_player.action &&
           evt.location == current_player.location &&
           !Game.completed_events.include?(evt.id)
         new_event = evt
         Game.add_completed_event(evt.id)
      end
    end

    set_event_and_script(new_event)
  end

  def set_event_and_script(new_event)
    if new_event
      self.event = new_event
      self.script = event && event.script ? event.script : nil
    end
  end

  def end_event
    self.event = nil
    self.script = nil
  end

  def display_event_description
    puts event.description if event.description
  end

  def player_move
    puts "Where would #{current_player.name} like to move to?"
    available_locations = current_player.available_paths
    new_location = Menu.choose_from_menu(available_locations)

    if new_location.area_id != current_player.location.area_id
      display_new_area_alert
      confirm_proceed_to_new_location(new_location)
    else
      current_player.location = new_location
    end
  end

  def display_new_area_alert
    display_summary
    puts "This will move the entire party to a new area. Are you sure you"
    puts "want to proceed?"
  end

  def confirm_proceed_to_new_location(location)
    choice = Menu.choose_from_menu(['yes', 'no'])
    if choice == 'yes'
      new_area = retrieve(location.area_id, areas)
      players.set_new_area(new_area, locations)
      puts "You collect your party and move to #{new_area}."
      Menu.prompt_continue
    else
      action_fail
    end
  end

  def player_examine
    puts "You see nothing else of interest."
    puts
  end

  def player_search
    puts "You find nothing of value."
    puts
  end

  def player_wait
    puts "#{current_player} is on alert!"
    puts
  end

  def player_use_item
    puts "#{current_player} uses an item."
    puts
  end

  def player_talk

  end

  def player_magic
    if current_player.casts_exhausted?
      display_no_casts_remaining
      action_fail
    elsif valid_spells?
      attempt_cast
    else
      display_no_useful_spells
      action_fail
    end
  end

  def valid_spells?
    current_player.spells.any? do |spell|
      spell.when == action_type
    end
  end

  def attempt_cast
    prepare_spell
    target = choose_spell_target

    if target
      display_summary
      launch_spell(current_player, target, players)
    else
      display_no_valid_targets
      action_fail
    end
  end

  def prepare_spell
    puts "What spell would #{current_player.name} like to use?"
    choose_and_equip_spell
  end

  def launch_spell(current_player, target, players)
    spell = current_player.equipped_spell

    if action_type == 'explore'
      current_player.spend_cast
      spell.cast_explore(current_player, target, players)
    elsif action_type == 'battle'
      living_enemies = enemies.reject { |enemy| enemy.dead? }
      current_player.spend_cast
      clear_conditions_if_hurt(target) do
        spell.cast_battle(current_player, target, players, living_enemies)
      end
    end
  end

  def choose_and_equip_spell
    available_spells = current_player.spells.select do |spell|
      spell.when == action_type
    end

    current_player.equipped_spell =
      Menu.choose_from_menu(available_spells) do
        available_spells.each_with_index do |spell, idx|
          puts "#{idx}. #{spell.display_name.ljust(20)}: " +
               "#{spell.stat_desc}"
        end
      end
  end

  def choose_spell_target
    if current_player.equipped_spell.target_type == 'enemy'
      targets = targets_in_range(enemies)
      return nil if targets.empty?
      select_enemy_to_attack(targets)
    elsif current_player.equipped_spell.target_type == 'player'
      select_player_to_cast_on
    elsif current_player.equipped_spell.target_type == 'self'
      current_player
    end
  end

  def select_player_to_cast_on
    targets = targets_in_range(players.to_a)
    return nil if targets.empty?

    puts "Which player would #{current_player.name} like to cast on?"
    choose_target_menu_with_location(targets)
  end

  def targets_in_range(targets)
    targets.select do |target|
      if current_player.action == 'attack'
        action_range = current_player.equipped_weapon.range
      elsif current_player.action == 'magic'
        action_range = current_player.equipped_spell.range
      end
      distance = current_player.location.distance_to(target.location)
      (action_range >= distance) && target.alive?
    end
  end

  def choose_target_menu_with_location(targets)
    Menu.choose_from_menu(targets) do
      targets.each_with_index do |target, idx|
        puts "#{idx}. #{target} at #{target.location.display_name} " +
             "(#{target.current_hp} HP)"
      end
    end
  end

  def player_equip
    available_equipment = current_player.backpack.all_unequipped_equipment

    if available_equipment.empty?
      puts 'Sorry, all equipment is currently in use...'
    else
      current_player.backpack.view_equippable(current_player)

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
      puts
      puts "#{current_player} equips #{choice}."
    end
  end

  def display_no_valid_targets
    display_ineffective_action do
      puts 'There are no valid targets close enough.'
      puts
      puts 'Please select another option...'
    end
  end

  def display_no_casts_remaining
    display_ineffective_action do
      puts 'You have no casts remaining in this battle.'
      puts
      puts 'Please select another option...'
    end
  end

  def display_no_useful_spells
    display_ineffective_action do
      puts 'None of your spells would be effective right now.'
      puts
      puts 'Please select another option...'
    end
  end

  def display_ineffective_action(&block)
    display_summary
    block.call
    puts
  end
end
