# frozen_string_literal: true

require 'open-uri'
require 'json'

VOWEL = /[aeiou]/i.freeze
LETTERS = ('A'..'Z').partition { |l| VOWEL.match(l) }.freeze

# Comment
class GamesController < ApplicationController
  def new
    vowels = (0...5).map { LETTERS[0].sample }.join
    consonants = (0...5).map { LETTERS[1].sample }.join
    letters = vowels + consonants
    @letters = letters.chars.shuffle
  end

  def score
    end_time = Time.now
    start_time = Time.parse(params[:start_time])
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word.downcase}"
    @word_exists = JSON.parse(open(url).read)['found']
    speed = end_time - start_time < 40 ? end_time - start_time : 40
    length_score = (
      1.fdiv((6**1.fdiv(8))) * (6**1.fdiv(8))**@word.length
    ).round(10)
    speed_score = (((0.2**1.fdiv(40))**speed * 5) - 1).round(10)
    letters = params[:letters]
    letters.gsub!(/(\,)(\S)/, '\\1 \\2')
    @letters = YAML.safe_load(letters)
    @word_meets_grid = @word.upcase.chars.all? do |char|
      @word.upcase.chars.count(char) <= @letters.count(char)
    end
    @score = if @word_exists && @word_meets_grid
               length_score + speed_score
             else
               0
             end
  end
end
