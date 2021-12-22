require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  compression, image = get_input

  2.times do
    image = apply_enhancement(compression, image)
  end

  puts image.join('').count('#')
end

def part2
  puts 'Part 2:'
  compression, image = get_input

  50.times do
    image = apply_enhancement(compression, image)
  end

  puts image.join('').count('#')
end

def apply_enhancement(compression, image)
  this_padding_char = image[0][0]
  next_padding_char = compression[this_padding_char == '#' ? 511 : 0]
  new_image = apply_padding(image, next_padding_char)
  image[0..].each_with_index do |line, x|
    (0 ... line.size).each do |y|
      bytes = [
        image[x-1][y-1],
        image[x-1][y],
        image[x-1][y+1] || this_padding_char,
        image[x][y-1],
        image[x][y],
        image[x][y+1] || this_padding_char,
        image[x+1]&.at(y-1) || this_padding_char,
        image[x+1]&.at(y) || this_padding_char,
        image[x+1]&.at(y+1) || this_padding_char
      ].join('').gsub('#', '1').gsub('.', '0')
      compression_index = bytes.to_i 2
      new_image[x+1][y+1] = compression[compression_index]
    end
  end

  new_image
end

def apply_padding(image, padding_char, times=1)
  new_image = []
  times.times do
    new_image << padding_char * (image[0].size + 2 * times)
  end
  image.each do |line|
    new_image << padding_char*times + line + padding_char*times
  end
  times.times do
    new_image << padding_char * (image[0].size + 2 * times)
  end

  new_image
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 20)
  compression, image = input.split("\n\n")
  [compression, apply_padding(image.split("\n"), '.', 2)]
end

def get_test_input(number)
  <<~TEST
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
