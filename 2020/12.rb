require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  input = get_input

  east, north = 0, 0
  direction = [1, 0]

  input.each do |line|
    action = line[0]
    amount = line[1..].to_i
    case action
    when 'N'
      north += amount
    when 'S'
      north -= amount
    when 'E'
      east += amount
    when 'W'
      east -= amount
    when 'L'
      direction = rotate_direction(direction, amount)
    when 'R'
      direction = rotate_direction(direction, -amount)
    when 'F'
      east += amount * direction[0]
      north += amount * direction[1]
    end
  end

  puts east.abs + north.abs
end

def part2
  puts 'Part 2:'
  input = get_input

  east, north = 0, 0
  direction = [10, 1]

  input.each do |line|
    action = line[0]
    amount = line[1..].to_i
    case action
    when 'N'
      direction[1] += amount
    when 'S'
      direction[1] -= amount
    when 'E'
      direction[0] += amount
    when 'W'
      direction[0] -= amount
    when 'L'
      direction = rotate_direction(direction, amount)
    when 'R'
      direction = rotate_direction(direction, -amount)
    when 'F'
      east += amount * direction[0]
      north += amount * direction[1]
    end
  end
  
  puts east.abs + north.abs
end

def rotate_direction(direction, amount)
  case amount % 360
  when 0
    direction
  when 90
    [-direction[1], direction[0]]
  when 180
    [-direction[0], -direction[1]]
  when 270
    [direction[1], -direction[0]]
  end
end

def get_input(test=false)
  input = test ? get_test_input : get_aoc_input(2020, 12)
  input.split("\n")
end

def get_test_input
  <<~TEST
  F10
  N3
  F7
  R90
  F11
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
