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
      puts
      print 'Hit return to continue...'
      gets
    end
  end
end
