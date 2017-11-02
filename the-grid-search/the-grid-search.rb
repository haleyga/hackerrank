#!/bin/ruby


def grid_has_pattern?(test_grid, g_rows, g_columns, pattern_grid, p_rows, p_columns)
  search_row = 0
  search_column = 0
  pattern_row = 0
  pattern_column = 0
  while search_row <= g_rows - p_rows
    # puts "\tchecking #{test_grid[search_row]} for #{pattern_grid[pattern_row]} starting at index #{search_column}"
    index = test_grid[search_row].index(pattern_grid[pattern_row], search_column)
    if !index
      search_column = 0
      search_row += 1
      # puts "\t\tnot found, incrementing search row index to #{search_row}"
      next
    end
    # puts "\tfound at index #{index}"

    similar_row_count = 1
    sub_search_row = search_row+1
    sub_search_column = search_column
    sub_pattern_row = pattern_row+1
    sub_pattern_column = pattern_column
    # puts "\tchecking for remaining pattern, similar count now #{similar_row_count}"
    while sub_search_row < g_rows && sub_search_column < g_columns && sub_pattern_row < p_rows && sub_pattern_column < p_columns
      # puts "\t\tchecking #{test_grid[sub_search_row]} for #{pattern_grid[sub_pattern_row]} starting at index #{search_column}"
      if index == test_grid[sub_search_row].index(pattern_grid[sub_pattern_row], search_column)
        sub_search_row += 1
        sub_pattern_row += 1
        similar_row_count += 1
        # puts "\t\t\tfound, similar count now #{similar_row_count}"
      else
        # puts "\t\t\tnot found, similar count ends with #{similar_row_count}"
        break
      end
    end

    # puts "\tdone checking remainder, similar count found was #{similar_row_count}, need #{p_rows}"
    return true if similar_row_count == p_rows
    # puts "\tnot enough, incrementing column to #{search_column+1}"
    search_column += 1
    if search_column > g_columns - p_columns
      # puts "\t\tsearch_column exceeded limit of #{g_columns - p_columns}, reset columns, increment rows"
      search_column = 0
      search_row += 1
    end
  end
  return false
end


test_case_count = gets.strip.to_i

(1..test_case_count).each do |t|
  line = gets.strip.split(' ').map(&:to_i)
  g_rows, g_columns = line[0], line[1]
  test_grid = []
  (1..g_rows).each do |r|
    test_grid.push gets.strip
  end
  line = gets.strip.split(' ').map(&:to_i)
  p_rows, p_columns = line[0], line[1]
  pattern_grid = []
  (1..p_rows).each do |r|
    pattern_grid.push gets.strip
  end

  puts grid_has_pattern?(test_grid, g_rows, g_columns, pattern_grid, p_rows, p_columns) ? 'YES' : 'NO'
end