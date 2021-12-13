require_relative '../aoc_defaults'
require 'matrix'

def part1
  puts 'Part 1:'
  input = get_input

  ship_pos = Vector[0, 0]
  direction = Vector[1, 0]

  input.each do |line|
    action = line[0]
    amount = line[1..].to_i
    case action
    when 'N'
      ship_pos[1] += amount
    when 'S'
      ship_pos[1] -= amount
    when 'E'
      ship_pos[0] += amount
    when 'W'
      ship_pos[0] -= amount
    when 'L'
      direction = rotate_direction(direction, amount)
    when 'R'
      direction = rotate_direction(direction, -amount)
    when 'F'
      ship_pos += amount * direction
    end
  end

  puts ship_pos.map(&:abs).sum.to_i
end

def part2
  puts 'Part 2:'
  input = get_input

  ship_pos = Vector[0, 0]
  direction = Vector[10, 1]

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
      ship_pos += amount * direction
    end
  end

  puts ship_pos.map(&:abs).sum.to_i
end

def rotate_direction(direction, amount)
  rotation = Matrix[[0, -1], [1, 0]]
  (rotation ** (amount / 90)) * direction
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
