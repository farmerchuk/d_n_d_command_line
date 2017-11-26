# dialogue_handler.rb

require_relative 'dnd'

class DialogueHandler
  include Helpers::Data

  attr_accessor :players, :areas, :locations, :dialogue

  def initialize(engagement_id, players, areas, locations)
    @players = players
    @areas = areas
    @locations = locations
    @dialogue = load_yaml_file(engagement_id)
  end

  def run
    display_dialogue_header
    active_banter = 'banter_1'

    loop do
      npc_banter = dialogue['npc'][active_banter]
      party_banter = dialogue['party'][active_banter]

      continue = execute_npc_banter(npc_banter)
      break unless continue

      active_banter = execute_party_banter(party_banter)
      break unless active_banter
    end

    Menu.prompt_end_dialogue
  end

  private

  def load_yaml_file(engagement_id)
    filename = engagement_id.split('_')[1..-1].join('_')

    YAML.load_file("../assets/yaml/dialogue/#{filename}.yml")
  end

  def execute_npc_banter(banter)
    puts banter['text']
    eval banter['script'] if banter['script']
    banter['continue']
  end

  def execute_party_banter(banter)
    choice = party_selects_response(banter)
    eval choice['script'] if choice['script']
    choice['next_banter']
  end

  def party_selects_response(banter)
    display_party_response_options(banter)

    choice = nil
    loop do
      choice = Menu.prompt
      break if (0..banter.size - 1).include?(choice.to_i) &&
        choice.match(/\d/)
      puts 'Sorry, that is not a valid choice...'
    end

    banter[choice.to_i]
  end

  def display_party_response_options(banter)
    puts
    puts "What would the party like to do?"
    banter.each_with_index do |response, idx|
      puts "#{idx}. #{response['text']}"
    end
  end

  def display_dialogue_header
    Menu.clear_screen
    puts 'Dialogue:'
    Menu.draw_line
    puts
  end
end
