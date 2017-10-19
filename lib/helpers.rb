module Helpers
  module Format
    def clear_screen
      system 'clear'
    end

    def prompt
      puts
      print '> '
      gets.chomp
    end

    def prompt_for_next_turn
      puts
      print "Hit RETURN to advance to next player's turn..."
      gets
    end
  end
end
