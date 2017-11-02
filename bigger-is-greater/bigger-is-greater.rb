def nextGreaterLexoOrder(s)
  (0..s.length-1).each do |i|
    newOrderFound = false
    indexToAlphabetize = nil
    (i+1..s.length-1).each do |j|
      curMin = 'z'
      indexCurMin = -1
      if s[j] < curMin
        curMin = s[j]
        indexCurMin = j
      end
      if curMin > s[i]
        temp = s[i]
        s[i] = s[indexCurMin]
        s[indexCurMin] = temp
        newOrderFound = true
        indexToAlphabetize = j+1
      end
    end
    if newOrderFound
      slice = s[indexToAlphabetize..s.length-1]
      return "#{s[0..indexToAlphabetize-1]}#{slice.chars.sort.join}"
    end
  end
  return 'no answer'
end


n = gets.strip.to_i

(0..n-1).each do |i|
  s = gets.strip.to_s
  puts nextGreaterLexoOrder s
end