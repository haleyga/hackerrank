
def travelUp
  nextPiece = ''
  $bottom_row.downto($top_row).each { |row| nextPiece.concat $array[row][$left_column] }
  $left_column += 1
  nextPiece
end

def travelRight
  nextPiece = ''
  ($left_column..$right_column).each { |column| nextPiece.concat $array[$top_row][column] }
  $top_row += 1
  nextPiece
end

def travelDown
  nextPiece = ''
  ($top_row..$bottom_row).each { |row| nextPiece.concat $array[row][$right_column] }
  $right_column -= 1
  nextPiece
end

def travelLeft
  nextPiece = ''
  $right_column.downto($left_column).each { |column| nextPiece.concat $array[$bottom_row][column] }
  $bottom_row -= 1
  nextPiece
end


line = gets.strip.split(' ').map(&:to_i)
n, m = line[0], line[1]

$array = []
(1..n).each { |i| $array.push gets.strip.split('') }

$left_column = 0
$right_column = m-1
$top_row = 0
$bottom_row = n-1

message = ''
max_length = n*m
while(true)
  message.length < max_length ? message.concat(travelUp) : break
  message.length < max_length ? message.concat(travelRight) : break
  message.length < max_length ? message.concat(travelDown) : break
  message.length < max_length ? message.concat(travelLeft) : break
end

# puts message
# puts message.gsub(/#+/, ' ')
puts (message.gsub(/#+/, ' ').split(' ').length)