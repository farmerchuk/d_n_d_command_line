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
  end

  module Prompts
    def prompt_continue
      puts
      print "Hit RETURN to continue..."
      gets
    end

    def prompt_for_next_turn
      puts
      print "Hit RETURN to advance to next player's turn..."
      gets
    end
  end

  module Messages
    def no_event_msg
      puts 'Nothing happens...'
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
  end
end
