module Hangman
  require_relative "format_color"
  require "erb"

  class RandomWord
    def self.get_word
      @google_words = File.open("google-10000-english-no-swears.txt", "r").readlines
      @random_word = String.new
      loop do
        # skip
        random_word = @google_words[rand(@google_words.length)][0...-1]
        break @random_word = random_word if random_word.length.between?(5, 12)
      end
      @random_word
    end
  end

  class Game
    def initialize(word, round_number = 0, save_chars = Array.new, correct_chars = Array.new)
      @word = word
      @round_number = round_number
      @save_chars = save_chars
      @correct_chars = correct_chars
      @word_split = @word.split("")
      @hangman = " " * @word.length
      @hangman_split = @hangman.split("")
    end

    def round_play
      puts "Select a char (or 'save', 'load', 'quit'):"
      @char_selection = gets.chomp
      if @char_selection == "save"
        save_state()
        exit
      elsif @char_selection == "load"
        load_state()
      elsif @char_selection == "quit"
        exit
      elsif @save_chars.include?(@char_selection)
        puts " "
        puts "Repeat move, char already typed before."
        self.round_play()
      else
        @save_chars.push(@char_selection)
        print_display()
        puts " "
      end
    end

    def rounds_to_play(rounds = @word.length + 10)
      # @round_number = 0

      while @round_number < rounds
        @round_number += 1

        puts "Round #{@round_number}"
        puts "Last movements:".ljust(20) + @save_chars.join(" ")
        puts "Correct movements:".ljust(20) + FormatColor.color(@correct_chars.uniq.join(" ").to_s, "green")

        round_play()

        @count_correct = 0
        @correct_chars.each do |char|
          if @word_split.include?(char)
            @count_correct += 1
          end
        end

        if @count_correct == @word_split.length
          puts "Congrats, you win! The word is " + @word
          puts @hangman_split.join(" ")
          break
        end

        if @round_number == rounds
          puts "Loser!"
          puts "The word is " + @word
          break
        end
      end
    end

    def print_display
      @hangman_split.each_with_index do |char, index|
        if @word_split[index] == @char_selection
          @correct_chars.push(@char_selection)
          @hangman_split[index] = FormatColor.color(@char_selection, "green").underline
        elsif @hangman_split[index] == " "
          @hangman_split[index] = FormatColor.color(" ", "white").underline
        end
      end
      puts @hangman_split.join(" ")
    end

    def save_state
      puts "Name of the saved file:"
      @save_name = gets.chomp
      save_template = File.read("save_state.erb")
      save_state = ERB.new(save_template)
      vars = save_state.result(binding)

      @dir_games = "saved_games"

      Dir.mkdir(@dir_games) unless Dir.exist?(@dir_games)

      filename = "#{@dir_games}/#{@save_name}.rb"

      File.open(filename, "w") do |file|
        file.puts vars
      end
    end

    def load_state
      puts " "
      puts "Existing data"
      puts Dir.glob("saved_games/*.rb")
      puts "Enter the filename to load:"
      filename = gets.chomp

      load_vars = File.read("saved_games/#{filename}.rb")

      eval(load_vars)

      puts " "
      puts "Load game:"
      print_display()
      puts " "
    end
  end
end
