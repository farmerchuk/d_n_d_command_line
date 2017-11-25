# menu.rb

class Menu
  def self.draw_line
    puts '-' * 108
  end

  def self.clear_screen
    system 'clear'
  end

  def self.prompt
    puts
    print '> '
    input = gets.chomp
    puts
    input
  end

  def self.prompt_continue
    puts
    print "Hit RETURN to continue..."
    gets
  end

  def self.prompt_encounter_start
    puts
    print "Hit RETURN to start the encounter..."
    gets
  end

  def self.prompt_end_dialogue
    puts
    print "Hit RETURN to end the dialogue..."
    gets
  end

  def self.prompt_end_player_turn
    puts
    print "Hit RETURN to end player's turn..."
    gets
  end

  def self.choose_from_menu(options)
    if block_given?
      yield
    else
      options.each_with_index do |el, idx|
        puts "#{idx}. #{el}"
      end
    end

    choice = nil
    loop do
      choice = self.prompt
      break if (0..options.size - 1).include?(choice.to_i) && choice.match(/\d/)
      puts 'Sorry, that is not a valid choice...'
    end
    options[choice.to_i]
  end

  def self.num_with_commas(int)
    ary = int.to_s.reverse.chars
    ary.each_slice(3).with_object([]) do |slice, new_ary|
      new_ary << slice.join("")
    end.join(',').reverse
  end
end
