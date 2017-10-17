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

    def continue
      print 'Hit any key to continue...'
      gets
    end
  end
end
