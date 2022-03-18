require_relative "hangman"

word = Hangman::RandomWord.get_word
game = Hangman::Game.new(word)

game.rounds_to_play
