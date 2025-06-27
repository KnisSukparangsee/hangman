fname = 'google-10000-english-no-swears.txt'
dictionary = []

File.readlines(fname).each do |line|
  dictionary.push(line.chomp)
end

valid_words = dictionary.select do |word|
  word.length >= 5 && word.length <= 12
end

random_word = valid_words.sample()

incorrect_letters = []
mystery_word = Array.new(random_word.length, '_')
guesses = 9


while guesses > 0 && mystery_word.any? { |word| word == '_' }
  puts "Remaining guesses #{guesses}"
  print 'Guess a letter: '
  guess = gets.chomp
  if guess.length != 1 || incorrect_letters.include?(guess)
    next
  end
  if random_word.include?(guess)
    indices = (0..random_word.length).find_all { |i| random_word[i, 1] == guess}
    indices.each do |index|
      mystery_word[index] = guess
    end
  else
    incorrect_letters.push(guess)
    guesses -= 1
  end
  puts
  puts mystery_word.join(' ')
  puts
  puts "Incorrect letters chosen: #{incorrect_letters.join}\n"
end

if mystery_word.any? { |word| word == '_' }
  puts "The word was \"#{random_word}\""
else
  puts 'You win!'
end