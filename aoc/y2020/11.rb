require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  input = get_input

  while true
    after_step = model_step_1(input)
    break if input.join('') == after_step.join('')
    input = after_step
  end

  puts input.join('').count '#'
end

def part2
  puts 'Part 2:'
  input = get_input

  while true
    after_step = model_step_2(input)
    break if input.join('') == after_step.join('')
    input = after_step
  end

  puts input.join('').count '#'
end

def model_step_1(lines)
  after_step = lines.deep_dup
  lines.each_with_index do |line, x|
    line.chars.each_with_index do |ch, y|
      if ch == '#'
        after_step[x][y] = lines.neighbors(x,y, true).count('#') >= 4 ? 'L' : '#'
      elsif ch == 'L'
        after_step[x][y] = lines.neighbors(x,y, true).count('#') == 0 ? '#' : 'L'
      end
    end
  end

  after_step
end

def model_step_2(lines)
  after_step = lines.deep_dup
  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  lines.each_with_index do |line, x|
    line.chars.each_with_index do |ch, y|
      next if ch == '.'

      neighbors = directions.map { |dir| get_first_seat(lines, x, y, dir[0], dir[1]) }
      if ch == '#'
        after_step[x][y] = neighbors.count('#') >= 5 ? 'L' : '#'
      elsif ch == 'L'
        after_step[x][y] = neighbors.count('#') == 0 ? '#' : 'L'
      end
    end
  end

  after_step
end

def get_first_seat(lines, x, y, dirx, diry)
  while true
    x += dirx
    y += diry
    break if x < 0 || y < 0 || x >= lines.size || y >= lines[x].size
    return lines[x][y] if lines[x][y] != '.'
  end
end

def get_input(test=false)
  input = test ? get_test_input : get_aoc_input(2020, 11)
  input.split("\n")
end

def get_test_input(year=nil, day=nil)
  <<~END
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
END
end

if __FILE__ == $0
  part1
  puts
  part2
end
