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
  end

  module Data
    def retrieve(id, array)
      selected = array.select { |el| el.id == id }
      raise StandardError, 'Multiple ids' if selected.size > 1
      selected.first
    end
  end
end
