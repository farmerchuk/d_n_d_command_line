# helpers.rb

module Helpers
  module Format
    def clear_screen
      system 'clear'
    end

    def prompt
      puts
      print '> '
      input = gets.chomp
      puts
      input
    end

    def num_with_commas(int)
      ary = int.to_s.reverse.chars
      ary.each_slice(3).with_object([]) do |slice, new_ary|
        new_ary << slice.join("")
      end.join(',').reverse
    end
  end

  module Prompts
    def prompt_continue
      puts
      print "Hit RETURN to continue..."
      gets
    end

    def prompt_for_next_turn
      puts
      print "Hit RETURN to advance to next turn..."
      gets
    end
  end

  module Messages
    def no_event_msg
      puts 'Nothing happens...'
    end

    def no_equippable_msg
      puts 'Sorry, all equipment is currently in use...'
    end
  end


  module Menus
    def choose_from_menu(options)
      options.each_with_index do |el, idx|
        puts "#{idx}. #{el}"
      end

      choice = nil
      loop do
        choice = prompt.to_i
        break if (0..options.size - 1).include?(choice)
        puts 'Sorry, that is not a valid choice...'
      end
      options[choice]
    end
  end

  module Dice
    def roll_d20
      rand(20) + 1
    end

    def roll_d12
      rand(12) + 1
    end

    def roll_d10
      rand(10) + 1
    end

    def roll_d8
      rand(8) + 1
    end

    def roll_d6
      rand(6) + 1
    end

    def roll_d4
      rand(4) + 1
    end

    def roll_dice(die_as_string)
      rolls, die, operator, adjustment = die_as_string.split(/[d ]/)
      total = 0

      case die
      when '4' then rolls.to_i.times { total += roll_d4 }
      when '6' then rolls.to_i.times { total += roll_d6 }
      when '8' then rolls.to_i.times { total += roll_d8 }
      when '10' then rolls.to_i.times { total += roll_d10 }
      when '12' then rolls.to_i.times { total += roll_d12 }
      when '20' then rolls.to_i.times { total += roll_d20 }
      end

      operator == '+' ? total += adjustment.to_i : total -= adjustment.to_i
    end
  end

  module Data
    def retrieve(id, array)
      selected = array.select { |el| el.id == id }
      selected.first
    end
  end

  module Displays
    def dm_describes_scene(players, current_player)
      clear_screen
      puts 'AREA DESCRIPTION:'
      puts '-----------------------------------------------------------------'
      puts current_player.area.description
      puts
      puts
      puts "CURRENT PLAYER: #{current_player}"
      puts '-----------------------------------------------------------------'
      puts "Location: The #{current_player.location.display_name}"
      puts
      puts current_player.location.description
      puts
      puts
      puts 'ALL PLAYERS QUICK SUMMARY:'
      puts '-----------------------------------------------------------------'
      players.each do |player|
        puts "#{player} " +
             "(#{player.race} #{player.role} / " +
             "#{player.current_hp} HP) " +
             "is at the #{player.location.display_name}"
      end
      puts
      puts
      puts 'GAME COMMANDS'
      puts '-----------------------------------------------------------------'
      puts
    end
  end
end
