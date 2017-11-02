#!/bin/ruby

n = gets.strip.to_i
grid = Array.new
(1..n).each do |row|
  grid.push gets.strip.split('').map(&:to_i)
end

(1..n-2).each do |i|
  (1..n-2).each do |j|
    cur = grid[i][j]
    up = grid[i-1][j]
    down = grid[i+1][j]
    left = grid[i][j-1]
    right = grid[i][j+1]
    next if up == 'X' || down == 'X' || left == 'X' || right == 'X'
    grid[i][j] = 'X' if cur > up && cur > down && cur > left && cur > right
  end
end

grid.each {|row| puts row.join}