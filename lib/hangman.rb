module Hangman
  require_relative "format_color"

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
    def initialize(word)
      @word = word
      @word_split = @word.split("")
      @hangman = " " * @word.length
      @hangman_split = @hangman.split("")
      @save_chars = Array.new
      @correct_chars = Array.new
    end

    def round_play
      puts "Select a char:"
      @char_selection = gets.chomp
      @save_chars.push(@char_selection)
      print_display()
      puts " "
    end

    def rounds_to_play(rounds = @word.length + 10)
      round_number = 0

      while round_number < rounds
        round_number += 1

        puts "Round #{round_number}"
        puts "Last movements:".ljust(20) + @save_chars.join(" ")
        puts "Correct movements:".ljust(20) + FormatColor.color(@correct_chars.uniq.join(" ").to_s, "green")

        round_play()

        count_correct = 0
        @correct_chars.each do |char|
          if @word_split.include?(char)
            count_correct += 1
          end
        end

        if round_number == rounds
          puts "Loser!"
          puts "The word is " + @word
        end
        break puts "Congrats, you win! The word is " + @word if count_correct == @word_split.length
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
  end
end
