class BoardLayout
  attr_accessor :winner

  def initialize(n, m, k, array)
    @row_count, @column_count, @k, @board = n, m, k, array.clone
    playGame
  end

  def printGameState
    printGameBoard
    printAlexisScoreState
    printOpponentScoreState
  end

  private

  def playGame
    analyzeBoard
    determineWinner
  end

  def analyzeBoard
    initializeCompetitorScoreMatrices
    (1..@row_count-1).each do |i|
      (1..@column_count-1).each do |j|
        current = @board[i][j]
        above = @board[i-1][j]
        left = @board[i][j-1]
        upper_left = @board[i-1][j-1]
        next if current == '-'
        incrementAlexisScore(i, j, above, left, upper_left) if current == 'O'
        incrementCompetitorScore(i, j, above, left, upper_left) if current == 'X'
      end
    end
  end

  def incrementAlexisScore(i, j, above, left, upper_left)
    score_above = @alexis_vertical_score_matrix[i-1][j]
    @alexis_vertical_score_matrix[i][j] = above == 'O' ? score_above + 1 : 1
    score_left = @alexis_horizontal_score_matrix[i][j-1]
    @alexis_horizontal_score_matrix[i][j] = left == 'O' ? score_left + 1 : 1
    score_upper_left = @alexis_diagonal_score_matrix[i-1][j-1]
    @alexis_diagonal_score_matrix[i][j] = upper_left == 'O' ? score_upper_left + 1 : 1
  end

  def incrementCompetitorScore(i, j, above, left, upper_left)
    score_above = @opponent_vertical_score_matrix[i-1][j]
    @opponent_vertical_score_matrix[i][j] = above == 'X' ? score_above + 1 : 1
    score_left = @opponent_horizontal_score_matrix[i][j-1]
    @opponent_horizontal_score_matrix[i][j] = left == 'X' ? score_left + 1 : 1
    score_upper_left = @opponent_diagonal_score_matrix[i-1][j-1]
    @opponent_diagonal_score_matrix[i][j] = upper_left == 'X' ? score_upper_left + 1 : 1
  end

  def determineWinner
    alexis_max = [@alexis_vertical_score_matrix.flatten.max, @alexis_horizontal_score_matrix.flatten.max, @alexis_diagonal_score_matrix.flatten.max].max
    opponent_max = [@opponent_vertical_score_matrix.flatten.max, @opponent_horizontal_score_matrix.flatten.max, @opponent_diagonal_score_matrix.flatten.max].max

    @winner = 'NONE' if [alexis_max, opponent_max].max < @k || alexis_max == opponent_max
    @winner = 'WIN' if alexis_max > opponent_max && alexis_max >= @k
    @winner = 'LOSE' if alexis_max < opponent_max && opponent_max >= @k
  end

  def initializeCompetitorScoreMatrices
    @alexis_vertical_score_matrix     = Array.new(@row_count) { |row| Array.new(@column_count, 0) }
    @opponent_vertical_score_matrix   = Array.new(@row_count) { |row| Array.new(@column_count, 0) }
    @alexis_horizontal_score_matrix   = Array.new(@row_count) { |row| Array.new(@column_count, 0) }
    @opponent_horizontal_score_matrix = Array.new(@row_count) { |row| Array.new(@column_count, 0) }
    @alexis_diagonal_score_matrix     = Array.new(@row_count) { |row| Array.new(@column_count, 0) }
    @opponent_diagonal_score_matrix   = Array.new(@row_count) { |row| Array.new(@column_count, 0) }

    @alexis_vertical_score_matrix[0][0]     = 1 if @board[0][0] == 'O'
    @opponent_vertical_score_matrix[0][0]   = 1 if @board[0][0] == 'X'
    @alexis_horizontal_score_matrix[0][0]   = 1 if @board[0][0] == 'O'
    @opponent_horizontal_score_matrix[0][0] = 1 if @board[0][0] == 'X'
    @alexis_diagonal_score_matrix[0][0]     = 1 if @board[0][0] == 'O'
    @opponent_diagonal_score_matrix[0][0]   = 1 if @board[0][0] == 'X'

    (1..@row_count-1).each do |i|
      @alexis_vertical_score_matrix[i][0]     = @alexis_vertical_score_matrix[i-1][0] + 1 if @board[i][0] == 'O'
      @opponent_vertical_score_matrix[i][0]   = @opponent_vertical_score_matrix[i-1][0] + 1 if @board[i][0] == 'X'
      @alexis_horizontal_score_matrix[i][0]   = 1 if @board[i][0] == 'O'
      @opponent_horizontal_score_matrix[i][0] = 1 if @board[i][0] == 'X'
      @alexis_diagonal_score_matrix[i][0]     = 1 if @board[i][0] == 'O'
      @opponent_diagonal_score_matrix[i][0]   = 1 if @board[i][0] == 'X'
    end

    (1..@column_count-1).each do |j|
      @alexis_vertical_score_matrix[0][j]     = 1 if @board[0][j] == 'O'
      @opponent_vertical_score_matrix[0][j]   = 1 if @board[0][j] == 'X'
      @alexis_horizontal_score_matrix[0][j]   = @alexis_horizontal_score_matrix[0][j-1] + 1 if @board[0][j] == 'O'
      @opponent_horizontal_score_matrix[0][j] = @opponent_horizontal_score_matrix[0][j-1] + 1 if @board[0][j] == 'X'
      @alexis_diagonal_score_matrix[0][j]     = 1 if @board[0][j] == 'O'
      @opponent_diagonal_score_matrix[0][j]   = 1 if @board[0][j] == 'X'
    end
  end

  def printGameBoard
    puts
    puts 'MAIN:'
    puts
    puts "\tgame board"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@board[i]}"
    end
  end

  def printAlexisScoreState
    puts
    puts 'ALEXIS:'
    puts
    puts "\talexis vertical score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@alexis_vertical_score_matrix[i]}"
    end
    puts "\talexis horizontal score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@alexis_horizontal_score_matrix[i]}"
    end
    puts "\talexis diagonal score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@alexis_diagonal_score_matrix[i]}"
    end
  end

  def printOpponentScoreState
    puts
    puts 'OPPONENT:'
    puts
    puts "\topponent vertical score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@opponent_vertical_score_matrix[i]}"
    end
    puts "\topponent horizontal score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@opponent_horizontal_score_matrix[i]}"
    end
    puts "\topponent diagonal score matrix"
    (0..@row_count-1).each do |i|
      puts "\t\t#{@opponent_diagonal_score_matrix[i]}"
    end
  end

end

game_count = gets.strip.to_i

(1..game_count).each do |game|
  line = gets.strip.split.map(&:to_i)
  n, m, k = line[0], line[1], line[2]
  matrix = []
  (1..n).each do |row_number|
    matrix.push gets.strip.split('')
  end
  game = BoardLayout.new(n, m, k, matrix)
  # game.printGameState
  # puts
  puts game.winner
  # puts
  # puts
end