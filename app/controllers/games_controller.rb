require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid]
    if session[:score].nil?
      session[:score] = 0
    end

    if !@guess.upcase.chars.all? { |letter| @guess.upcase.count(letter) <= @grid.upcase.count(letter) }
      @score = "Sorry but #{@guess.upcase} can't be built out of #{@grid.split.join(", ")}"
      session.delete(:score)
    elsif !word_valid?(@guess)
      @score = "Sorry but #{@guess.upcase} does not seem to be a valid English word..."
      session.delete(:score)
    else
      session[:score] += @guess.size
      @score = "Congratulations! #{@guess.upcase} is a valid English word! Your score is #{session[:score]}"
    end
  end

  private

  def word_valid?(guess)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
