# explore_action_handler.rb

require_relative 'dnd'

class ExploreActionHandler
  include PlayerActionHandler

  attr_accessor :players, :current_player, :locations

  def initialize(players, locations)
    @players = players
    @current_player = players.current
    @locations = locations
  end

  def action_type
    'explore'
  end

  def display_summary
    self.class.display_summary(players)
  end

  def self.display_summary(players)
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS'
    Menu.draw_line
    players.each do |player|
      puts "#{player.to_s.ljust(12)}" +
           "(#{player.race} #{player.role} / #{player.current_hp} HP)".ljust(28) +
           "is at the #{player.location.display_name}".ljust(33) +
           (player.current_turn ? "<< Current Player" : "")
    end
    puts
    puts
    puts "CURRENT PLAYER LOCATION #{players.current.location.display_name}"
    Menu.draw_line
    puts players.current.location.description
    puts
    puts
    puts 'EXPLORATION DETAILS'
    Menu.draw_line
  end
end
