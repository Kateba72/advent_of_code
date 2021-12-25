require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  field = get_input

  (1..).each do |i|
    field, moved = move(field)
    unless moved
      puts i
      break
    end
  end

end

def move(field)
  moved = false
  new_field = field.deep_dup
  field.each_with_index do |line, x|
    line.chars.each_with_index do |ch, y|
      if ch == '>' && line[(y + 1) % line.size] == '.'
        new_field[x][y] = '.'
        new_field[x][(y + 1) % line.size] = '>'
        moved = true
      end
    end
  end

  field = new_field.deep_dup
  field.each_with_index do |line, x|
    line.chars.each_with_index do |ch, y|
      if ch == 'v' && field[(x + 1) % field.size][y] == '.'
        new_field[x][y] = '.'
        new_field[(x + 1) % field.size][y] = 'v'
        moved = true
      end
    end
  end
  [new_field, moved]
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 25)
  input.split("\n")
end

def get_test_input(number)
  <<~TEST
  v...>>.vv>
  .vv>>.vv..
  >>.>v>...v
  >>v>>.>.v.
  v>v.vv.v..
  >.>>..v...
  .vv..>.>v.
  v.v..>>v.v
  ....v..v.>
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
