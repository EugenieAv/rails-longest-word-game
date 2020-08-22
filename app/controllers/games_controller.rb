require 'json'
require 'open-uri'

class GamesController < ApplicationController
  VOYELS = %w(A E I O U)
  def new
     @voys = VOYELS.sample(5)
     @cons = (('A'..'Z').to_a - VOYELS).sample(5)
     @letters = (@voys + @cons).shuffle
  end

  def score
    @grid = params[:grid].split
    @guess = params[:guess].upcase.split
    @included = in_the_grid?(@grid, @guess)
    @english_word = is_english_word?(@guess)

    # if in_the_grid?(@grid, @guess) && is_english_word(@guess)
    #   @message = "votre mot est correct"
    # elsif !is_english_word?(@guess)
    #   @message = "it 's not an english word"
    # else
    #   @message = 'try again'
    # end
  end

  private

  def in_the_grid?(grid,guess)
    grid_hash  = Hash.new(0)
    grid.each { |letter| grid_hash[letter] += 1 }

    guess_hash = Hash.new(0)
    guess.each { |letter| guess_hash[letter] += 1}

    guess_keys = guess_hash.keys
    res = guess_keys.all? do |letter|
      grid_hash[letter] - guess_hash[letter] >= 0
    end
    return res
  end

  def is_english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/:#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

end
