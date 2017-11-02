
$sequence_map = Hash.new
$super_valid_map = Hash.new

def isSuperValid(s, k)
  count = 0
  (0..s.length-2).each do |i|
    count += 1 if s[i] != s[i+1]
    return count >= k
  end
end

def getValidSequences(n)
  if n == 0
    $sequence_map[n] = ''
    return
  end
  if n == 2
    $sequence_map[n] = '()'
    return
  end
  current = ''
  (1..n-2).step(2) do |i|
    current.concat('(').concat(getValidSequences(n-i-2)).concat(')')
  end
end

def calibrateAnswer(answer)
  (answer % 10**9) + 7
end

# puts ans % 10**9 + 7
query_count = gets.strip.to_i
(1..query_count).each do |query|
  line = gets.strip.split.map(&:to_i)
  n, k = line[0], line[1]
  if !$super_valid_map.key? [n,k]
    sequences = getValidSequences n, ''
    $super_valid_map[[n,k]] = calibrateAnswer (sequences.map { |sequence| isSuperValid(sequence, k) }).count(true)
  end
  puts $super_valid_map[[n,k]]
end