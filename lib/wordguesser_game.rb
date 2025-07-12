class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    # raise an error if letter isn't an alphabetical character
    raise ArgumentError unless letter =~ /^[a-zA-Z]/

    # convert letter to lowercase for case insensitive
    letter = letter.downcase

    # return false if letter has already been guessed
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    # letter hasn't been guessed, so we add to the appropriate string
    @word.downcase.include?(letter) ? @guesses += letter : @wrong_guesses += letter

    # a valid guess has been made (regardless of correctness)
    return true
  end

  def word_with_guesses
    @word.chars.map do |letter|
      @guesses.include?(letter) ? letter : "-"
    end.join
  end

  def check_win_or_lose
    if @word == self.word_with_guesses
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end