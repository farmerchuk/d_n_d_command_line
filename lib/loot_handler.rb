# loot_handler.rb

require_relative 'dnd'

class LootHandler
  attr_accessor :players, :party_backpack,
                :gold, :weapons, :armors, :accessories, :all_loot

  def initialize(loot_id, players)
    @players = players
    @party_backpack = players.first.backpack
    @gold = nil
    @weapons = []
    @armors = []
    @accessories = []
    generate_loot(loot_id)
    @all_loot = weapons + armors + accessories
  end

  def run
    party_backpack.purse + gold
    all_loot << 'ALL' << 'DONE'

    loop do
      display_loot_header
      display_gold_found if gold
      remove_all_option_if_no_loot
      display_menu_of_loot

      selected_loot = player_selects_option
      if selected_loot.kind_of?(Equipment)
        add_loot(selected_loot)
      else
        add_all_loot if selected_loot == 'ALL'
        break
      end

      Menu.prompt_continue
    end
  end

  def display_loot_header
    Menu.clear_screen
    puts 'Loot Found:'
    Menu.draw_line
    puts
  end

  private

  def generate_loot(loot_id)
    loot_data = YAML.load_file('../assets/yaml/loot.yml')
    loot = loot_data.find { |loot| loot['id'] == loot_id }

    self.gold = loot['gold']

    loot['weapons'].each do |weapon_id|
      weapons << Equipment.build_weapon(weapon_id)
    end

    loot['armors'].each do |armor_id|
      armors << Equipment.build_armor(armor_id)
    end

    loot['accessories'].each do |accessory_id|
      accessories << Equipment.build_accessory(accessory_id)
    end
  end

  def display_gold_found
    puts "You found #{gold} gold and put it into your coin purse."
    puts
  end

  def display_menu_of_loot
    puts "You've found equipment. What would you like to keep?"
    all_loot.each_with_index do |loot, idx|
      puts "#{idx}. #{loot}"
    end
  end

  def remove_all_option_if_no_loot
    if all_loot.none? { |loot| loot.kind_of?(Equipment) }
      all_loot.reject! { |loot| loot == 'ALL' }
    end
  end

  def player_selects_option
    choice = nil
    loop do
      choice = Menu.prompt
      break if (0..all_loot.size - 1).include?(choice.to_i) && choice.match(/\d/)
      puts 'Sorry, that is not a valid choice...'
    end

    all_loot[choice.to_i]
  end

  def add_loot(selected_loot)
    puts
    puts "#{selected_loot} added to backpack."
    party_backpack.add(selected_loot)
    all_loot.reject! { |loot| loot == selected_loot }
  end

  def add_all_loot
    puts
    puts "All loot added to backpack."
    all_loot.each do |loot|
      party_backpack.add(loot) if loot.kind_of?(Equipment)
    end
  end
end
