require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(8)
  end

  def score
    @grid = params[:grid].split # lettre generées aléatoirement
    @guess = params[:guess].upcase.split

    if in_the_grid?(@grid, @guess) && is_english_word(@guess)
      @message = "votre mot est correct"
    elsif !is_english_word?(@guess)
      @message = "it 's not an english word"
    else
      @message = 'try again'
    end
  end


    # grid = params[:grid] # lettre generées aléatoirement
    # input_word = input_word.split # => créer un array
    # grid = grid.split
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
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    user['found']
  end

end
