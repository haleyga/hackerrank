
test_case_count = gets.strip.to_i

(1..test_case_count).each do |t|
  array_size = gets.strip.to_i
  array = gets.strip.split(' ').map(&:to_i)
  sorted_array = array.sort

  (0..array_size-4).each do |i|
    # puts "\tcurrent state: #{array}, i #{i}"
    target = sorted_array[i]
    index = array.index target

    until array[i] == target
      (1..3).each do |rotation|
        break if array[i] == target
        if index == array_size-1
          swap = array[index-2]
          array[index-2] = array[index]
          array[index] = array[index-1]
          array[index-1] = swap
          index -= 2
        else
          swap = array[index-1]
          array[index-1] = array[index]
          array[index] = array[index+1]
          array[index+1] = swap
          index -= 1
        end
      end
    end

  end

  # puts "final state: #{array}"
  # puts "end slice: #{array.slice(array_size-3, 3)}"

  can_be_sorted = false
  end_slice = array.slice(array_size-3, 3)
  sorted_end_slice = end_slice.sort
  (1..3).each do |rotation|
    if end_slice == sorted_end_slice
      can_be_sorted = true
      break
    end
    end_slice.rotate!
  end

  puts can_be_sorted ? 'YES' : 'NO'
end