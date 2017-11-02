def check_if_sorted_after_reverse_fix(array, start, count)
  puts "check_if_sorted_after_fix; start: #{start}, count: #{count}"
  sorted_array = array.sort
  # puts "array: #{array.join(' ')}"
  # puts "sorted_array: #{sorted_array.join(' ')}"

  before_unsorted_piece = array.slice 0, start
  # puts "before_unsorted_piece: #{before_unsorted_piece.join(' ')}"
  unsorted_piece = array.slice start, count
  # puts "unsorted_piece: #{unsorted_piece.join(' ')}"
  after_unsorted_piece = array.slice start+count, array.length-start+count
  # puts "after_unsorted_piece: #{after_unsorted_piece.join(' ')}"

  test_array = before_unsorted_piece.concat(unsorted_piece.sort!).concat(after_unsorted_piece)
  # puts "test_array: #{test_array.join(' ')}"

  if sorted_array == test_array
    if count == 2
      return "yes\nswap #{start+1} #{start+2}"
    else
      return "yes\nreverse #{start+1} #{start+count}"
    end
  end
  return 'no'
end

def check_if_sorted_after_swap_fix(array, targets)
  first = targets[0]
  second = targets[1]
  sorted_array = array.sort

  temp = array[first]
  array[first] = array[second]
  array[second] = temp

  if sorted_array == test_array
    return "yes\nswap #{first+1} #{second+1}"
  else
    return 'no'
  end
end

def almost_sorted?(array)
  sorted_array = array.sort

  if array == sorted_array
    return 'yes'
  end

  first = array[0]
  puts "first: #{first}"
  second = array[1]
  puts "second: #{second}"

  increasing = second-first > 0 ? true : false
  puts "increasing: #{increasing}"
  decreasing = !increasing
  puts "decreasing: #{decreasing}"

  if array.length == 2
    return 'yes' if increasing
    return "yes\nswap 1 2"
  end

  swap_targets = []
  last = second
  puts "last: #{last}"
  if decreasing
    start_of_unsorted = 0
    unsorted_count = 2
    unsorted_segments_count = 1
  else
    start_of_unsorted = -1
    unsorted_count = 0
    unsorted_segments_count = 0
  end

  puts "start_of_unsorted: #{start_of_unsorted}"
  puts "unsorted_count: #{unsorted_count}"
  puts "unsorted_segments_count: #{unsorted_segments_count}"

  (2..array.length-1).each do |i|
    puts "\n\ti: #{i}"
    current = array[i]
    puts "\tcurrent: #{current}"
    if increasing && current - last < 0
      puts "\t\tincreasing; current - last: #{current - last}"
      start_of_unsorted = i-1
      puts "\t\tstart_of_unsorted: #{start_of_unsorted}"
      unsorted_count += 1
      puts "\t\tunsorted_count: #{unsorted_count}"
      unsorted_segments_count += 1
      puts "\t\tunsorted_segments_count: #{unsorted_segments_count}"
      decreasing = increasing
      # puts "\t\tdecreasing: #{decreasing}"
      increasing = !decreasing
      # puts "\t\tincreasing: #{increasing}"
    elsif decreasing && current - last > 0
      puts "\t\tdecreasing; current - last: #{current - last}"
      increasing = decreasing
      # puts "\t\tincreasing: #{increasing}"
      decreasing = !increasing
      # puts "\t\tdecreasing: #{decreasing}"
      break
    end

    if increasing
      if unsorted_count == 1
        puts "\t\t\tadding swap target: #{start_of_unsorted}"
        swap_targets.push start_of_unsorted
      end
      unsorted_count = 0
      puts "\t\tincreasing; unsorted_count: #{unsorted_count}"
    end

    if decreasing
      unsorted_count += 1
      puts "\t\tdecreasing; unsorted_count: #{unsorted_count}"
    end

    last = current
    puts "\tlast: #{last}"

  end

  if swap_targets.length == 2 && unsorted_segments_count == 2

  end

  if swap_targets.length == 0 && unsorted_segments_count == 1
    return check_if_sorted_after_reverse_fix array, start_of_unsorted, unsorted_count
  end

  'no'

end


n = gets.strip.to_i
array = gets.strip.split(' ').map(&:to_i)
puts almost_sorted? array
