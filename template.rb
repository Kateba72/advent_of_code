require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  input = get_input

end

def part2
  puts 'Part 2:'
  input = get_input

end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(%year%, %day%)
  input.split("\n")
end

def get_test_input(number)
  <<~TEST
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
