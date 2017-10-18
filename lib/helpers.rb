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

    def next_turn
      puts
      print 'Hit RETURN to advance to next turn...'
      gets
    end
  end
end
