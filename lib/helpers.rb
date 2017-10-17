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
  end
end
