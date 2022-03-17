module Hangman
  class RandomWord
    def self.get_word
      @google_words = File.open("google-10000-english-no-swears.txt", "r").readlines
      @random_word = String.new
      loop do
        # skip \n
        random_word = @google_words[rand(@google_words.length)][0...-1]
        break @random_word = random_word if random_word.length.between?(5, 12)
      end
      @random_word
    end
  end
end
