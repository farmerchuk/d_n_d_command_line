# player_explore.rb

require_relative 'dnd'

class PlayerExplore < PlayerActionHandler

  attr_reader :action_type

  def initialize(players, locations, areas)
    super
    @action_type = 'explore'
  end

  def player_hide
    puts "#{current_player} disappears into the shadows."
    puts
    current_player.add_condition('hidden')
  end

  def display_summary
    Menu.clear_screen
    puts 'ALL PLAYERS & DETAILS'
    Menu.draw_line
    puts "NAME".ljust(14) +
         "RACE".ljust(12) +
         "ROLE".ljust(12) +
         "HP".rjust(4) + ' / '.ljust(3) +
         "MAX".ljust(8) +
         "CONDITIONS".ljust(14) +
         "LOCATION".ljust(24)
    puts
    players.each do |player|
      player_hps = player.current_hp <= 0 ? 'DEAD' : player.current_hp

      if player.current_turn
        color = :yellow
      else
        color = :white
      end

      line =
        player.name.ljust(14) +
        player.race.to_s.ljust(12) +
        player.role.to_s.capitalize.ljust(12) +
        player_hps.to_s.rjust(4) + ' / '.ljust(3) +
        player.max_hp.to_s.ljust(8) +
        player.cond_acronym.join(' ').ljust(14) +
        player.location.display_name.ljust(24) +
        (player.current_turn ? '<< Current Player' : '')

      puts line.colorize(color)
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
