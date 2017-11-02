def populateStateSpace(n)
  pile_sizes = [n]
  until pile_sizes.empty?
    pile_size = pile_sizes.shift
    next if $pile_size_state_map.key? pile_size
    valid_next_states = []
    $divisors.each do |divisor|
      next if divisor > pile_size
      if pile_size % divisor == 0
        new_pile_size = pile_size/divisor
        valid_next_states.push [new_pile_size]*divisor
        pile_sizes.push new_pile_size
      end
    end
    $pile_size_state_map[pile_size] = valid_next_states
  end
end

def getNimber(pile_size)
  puts
  puts "\tpile_size: #{pile_size}"
  puts "\tnimbers: #{$pile_size_nimber_map}"
  return $pile_size_nimber_map[pile_size] if $pile_size_nimber_map.key? pile_size

  # nimber = 0
  min_path = nil
  $pile_size_state_map[pile_size].each do |state|
    puts "\t\tstate: #{state}"
    current_path = 0
    state.each do |substate_pile_size|
      current_path += $pile_size_nimber_map[substate_pile_size] || getNimber(substate_pile_size)
      puts
      min_path ||= current_path
    end
    min_path = [min_path, current_path].min
  end
  nimber = min_path

  puts "\tnimber: #{nimber}, pile_size substate count: #{$pile_size_state_map[pile_size].length}"
  $pile_size_nimber_map[pile_size] = nimber + $pile_size_state_map[pile_size].length
  puts "\t$pile_size_nimber_map[pile_size]: #{$pile_size_nimber_map[pile_size]}"
  $pile_size_nimber_map[pile_size]
end


line = gets.strip.split(' ').map(&:to_i)
n, m = line[0], line[1]

$divisors = gets.strip.split(' ').map(&:to_i)

$pile_size_state_map  = Hash.new
$pile_size_nimber_map = Hash.new

populateStateSpace n
$pile_size_nimber_map[0] = 0
$pile_size_nimber_map[1] = 0

puts "$pile_size_state_map: #{$pile_size_state_map}"
puts getNimber(n) % 2 == 0 ? 'First' : 'Second'
puts "$pile_size_nimber_map: #{$pile_size_nimber_map}"