n = gets.to_i
master_progression = Array.new

(0..(n-1)).each { |_| master_progression.push gets.to_i }
# puts "master_progression: #{master_progression.join ' '}"

all_arrs = Array.new [[]]
count = 1

(0..n-1).each do |i|
  # itemp_arr = Array.new [master_progression[i]]
  # all_arrs.push itemp_arr
  count += 1
  (i+1..n-1).each do |j|
    # jtemp_arr = Array.new itemp_arr
    # jtemp_arr.push master_progression[j]
    # all_arrs.push jtemp_arr
    count += 1
    cur_d = j - i
    (j+1..n-1).each do |k|
      # ktemp_arr = Array.new jtemp_arr
      if master_progression[k] == master_progression[i] + (k-i)*cur_d then
        # ktemp_arr.push master_progression[k]
        # all_arrs.push ktemp_arr
        count += 1
      else
        break
      end
    end
  end
end
#
# puts "all_arrs: "
# all_arrs.each { |arr| puts "\n\t #{arr}" }
# puts all_arrs.count
puts count
