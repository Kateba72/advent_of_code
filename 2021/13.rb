require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  points, instructions = get_input

  points = execute_instruction(points, instructions.first)

  puts points.count
  puts
end

def part2
  puts 'Part 2:'
  points, instructions = get_input

  instructions.each do |instruction|
    points = execute_instruction(points, instruction)
  end

  output = (1..6).map { |_| ' ' * 40 }
  points.each do |point|
    output[point[1]][point[0]] = '#'
  end

  puts output
end

def get_input(test=false)
  points, instructions = test ? get_test_input.split("\n\n") : get_aoc_input(2021, 13).split("\n\n")
  points = points.split("\n").map do |line|
    x, y = line.split(',')
    [x.to_i, y.to_i]
  end
  instructions = instructions.split("\n").map do |line|
    /fold along ([xy])=(\d+)/.match line do |m|
      {
        value_x: m[1] == 'x' ? m[2].to_i : 10000,
        value_y: m[1] == 'y' ? m[2].to_i : 10000,
      }
    end
  end
  [points, instructions]
end

def execute_instruction(points, instruction)
  points = points.map do |point|
    new_x = point[0] > instruction[:value_x] ? 2 * instruction[:value_x] - point[0] : point[0]
    new_y = point[1] > instruction[:value_y] ? 2 * instruction[:value_y] - point[1] : point[1]
    [new_x, new_y]
  end.uniq
end

def get_test_input
  <<~TEST
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
  TEST
end

if __FILE__ == $0
  part1
  part2
end
