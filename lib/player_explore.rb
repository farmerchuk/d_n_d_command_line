# player_explore.rb

require_relative 'dnd'

class PlayerExplore < PlayerActionHandler

  attr_reader :action_type

  def initialize(players, locations)
    super
    @action_type = 'explore'
  end

  def display_summary
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS'
    Menu.draw_line
    players.each do |player|
      if player.alive?
        puts "#{player.to_s.ljust(12)}" +
             "#{player.race} #{player.role} / #{player.current_hp} HP".ljust(28) +
             "is at the #{player.location.display_name}".ljust(33) +
             (player.current_turn ? "<< Current Player" : "")
      else
        puts "#{entity.to_s.ljust(12)}" + "DEAD".ljust(28) +
             "is at the #{entity.location.display_name}".ljust(33)
      end
    end
    puts
    puts
    puts "CURRENT PLAYER LOCATION: #{players.current.location.display_name}"
    Menu.draw_line
    puts players.current.location.description
    puts
    puts
    puts 'EXPLORATION DETAILS'
    Menu.draw_line
  end
end
