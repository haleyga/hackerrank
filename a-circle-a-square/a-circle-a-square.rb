class Circle
  attr_accessor :center
  attr_accessor :radius

  def initialize(x, y, r)
    @center = Point.new(x, y)
    @radius = r
  end

end

class Square
  attr_accessor :corner_one
  attr_accessor :corner_two
  attr_accessor :corner_three
  attr_accessor :corner_four

  def initialize(x1, y1, x3, y3)
    @corner_one = Point.new(x1, y1)
    @corner_three = Point.new(x3, y3)
    @corner_two, @corner_four = find_missing_square_points(x1, y1, x3, y3)

  end

  private

    def find_missing_square_points(x1, y1, x3, y3)
      return Point.new(((x1+x3+y3-y1)/2),((y1+y3+x1-x3)/2)), Point.new(((x1+x3+y1-y3)/2),((y1+y3+x3-x1)/2))
    end

end

class Point
  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x, @y = x, y
  end

end

class Screen

  def initialize(width, height)
    @height = height
    @width = width
    @screen = Array.new(height)
    (0..height-1).each do |row|
      @screen[row] = ['.'] * width
    end
  end

  def fill_circle(circle)
    y_start = circle.center.y - circle.radius
    y_end = circle.center.y + circle.radius
    x_start = circle.center.x - circle.radius
    x_end = circle.center.x + circle.radius

    (y_start..y_end).each do |row|
      (x_start..x_end).each do |column|

        next if row < 0 || row > @height - 1 || column < 0 || column > @width - 1

        if circle.center.x < 0
          adjusted_center_x = 0
          adjusted_column = column + circle.center.x.abs
        elsif circle.center.x > @width - 1
          adjusted_center_x = @width - 1
          adjusted_column = column - circle.center.x
        else
          adjusted_center_x = circle.center.x
          adjusted_column = column
        end

        if circle.center.y < 0
          adjusted_center_y = 0
          adjusted_row = row + circle.center.y.abs
        elsif circle.center.y > @height - 1
          adjusted_center_y = @height - 1
          adjusted_row = row - circle.center.y
        else
          adjusted_center_y = circle.center.y
          adjusted_row = row
        end

        @screen[row][column] = '#' if get_distance(Point.new(adjusted_column, adjusted_row), Point.new(adjusted_center_x, adjusted_center_y)) <= circle.radius
      end
    end
  end

  def fill_square(square)
    @screen[square.corner_one.y][square.corner_one.x] = '#' if square.corner_one.y >= 0 && square.corner_one.x > 0
    @screen[square.corner_two.y][square.corner_two.x] = '#' if square.corner_two.y >= 0 && square.corner_two.x > 0
    @screen[square.corner_three.y][square.corner_three.x] = '#' if square.corner_three.y >= 0 && square.corner_three.x > 0
    @screen[square.corner_four.y][square.corner_four.x] = '#' if square.corner_four.y >= 0 && square.corner_four.x > 0
  end

  def print_screen
    @screen.each do |row|
      puts row.join('')
    end
  end

  private

    def get_distance(p1, p2)
      Math.sqrt((p2.x-p1.x)**2 + (p2.y-p1.y)**2)
    end

end



line = gets.strip.split(' ').map(&:to_i)
screen = Screen.new(line[0], line[1])

line = gets.strip.split(' ').map(&:to_i)
circle = Circle.new(line[0], line[1], line[2])

line = gets.strip.split(' ').map(&:to_i)
square = Square.new(line[0], line[1], line[2], line[3])

screen.print_screen
puts
screen.fill_circle circle
puts
screen.print_screen
# puts
# screen.fill_square square
# puts
# screen.print_screen