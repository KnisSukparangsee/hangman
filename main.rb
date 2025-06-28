require 'yaml'

class Game
  attr_accessor :secret_word, :misses, :hits, :guesses

  def initialize(secret_word, misses, hits, guesses)
    @secret_word = secret_word
    @misses = misses
    @hits = hits
    @guesses = guesses
  end

  def to_yaml
    YAML.dump ({
      :secret_word => @secret_word,
      :misses => @misses,
      :hits => @hits,
      :guesses => @guesses
    })
  end

  def from_yaml(string)
    data = YAML.load string
    save = Game.new(data[:secret_word], data[:misses], data[:hits], data[:guesses])
    puts
    puts save.hits.join(' ')
    puts
    puts "Incorrect letters chosen: #{save.misses.join}\n"
    save
  end

  def save(string)
    File.open('save.txt', 'w') do |f|
      f.puts string
    end
  end

  def load
    string = ""
    File.readlines('save.txt').each do |line|
      string << line
    end
    string
  end

  def play
    while @guesses > 0 && @hits.any? { |letter| letter == '_' }
      puts "Remaining guesses: #{@guesses}"
      puts 'Press + to save - to load game'
      print 'Guess a letter: '
      guess = gets.chomp.downcase
      if guess.length != 1 || @misses.include?(guess)
        next
      elsif guess == '+'
        string = self.to_yaml
        save(string)
        puts 'Game saved'
        next
      elsif guess == '-'
        string = load
        puts
        puts 'Previous save loaded'
        from_yaml(string).play
        return
      end
      if secret_word.include?(guess)
        indices = (0..secret_word.length).find_all { |i| secret_word[i, 1] == guess}
        indices.each do |index|
          @hits[index] = guess
        end
        if @hits.all? { |letter| letter != '_' }
          break
        end
      else
        @misses.push(guess)
        @guesses -= 1
      end
      puts
      puts @hits.join(' ')
      puts
      puts "Incorrect letters chosen: #{@misses.join}\n"
    end

    puts
    puts @hits.join(' ')
    puts
    
    if @hits.any? { |letter| letter == '_' }
      puts 'You lose!'
      puts "The word was \"#{secret_word}\""
    else
      puts 'You win!'
    end    
  end
end

fname = 'google-10000-english-no-swears.txt'
dictionary = []

File.readlines(fname).each do |line|
  dictionary.push(line.chomp)
end

valid_words = dictionary.select do |word|
  word.length >= 5 && word.length <= 12
end

secret_word = valid_words.sample()
misses = []
hits = Array.new(secret_word.length, '_')
guesses = 9
Game.new(secret_word, misses, hits, guesses).play