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

    def choose_num(options)
      choice = nil
      loop do
        choice = prompt.to_i
        break if (options).include?(choice)
        puts 'Sorry, that is not a valid choice...'
      end
      choice
    end

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

    def no_event_msg
      puts 'Nothing happens...'
    end

    def roll_d20
      rand(20) + 1
    end
  end
end
