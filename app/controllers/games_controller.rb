require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    number_of_letters = rand(1..26)
    alphabet = ("a".."z").to_a
    # @letters = alphabet.sample(number_of_letters)
    @letters = alphabet.sample(10)
    session[:current_score] ||= 0
  end


  def fetch_api(word)
    url = "https://dictionary.lewagon.com/#{word}"
    word_serialized = URI.parse(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end

  def score
    if params[:word] != ""
      word = params[:word]
      letters = params[:letters].split(" ")
      word_array= word.split("") 
      check = word_array.all? do |letter|
        letters.delete(letter) if letters.include?(letter)
      end
      if check == true
        #regarder si le mot est correct vs API
        # debugger
        if fetch_api(word.downcase) 
          @result = "Congrats !!"
          session[:current_score] += 1
          @score = session[:current_score]
        else
          @result = "I guess you are crying"
        end
      else 
        #mauvaise correspondance des lettres
        # debugger
        @result = "One or several letter(s) are not matching"
      end
    else
      #aucun mot saisi
      @result = "No word sent"
    end
  end



  def home
  end
end
