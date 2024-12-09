require_relative '../solution'

module AoC
  module Y2021
    class D20 < Solution

      def part1
        compression, image = parse_input

        2.times do
          image = apply_enhancement(compression, image)
        end

        image.join.count('#')
      end

      def part2
        compression, image = parse_input

        50.times do
          image = apply_enhancement(compression, image)
        end

        image.join.count('#')
      end

      def apply_enhancement(compression, image)
        this_padding_char = image[0][0]
        next_padding_char = compression[this_padding_char == '#' ? 511 : 0]
        new_image = apply_padding(image, next_padding_char)
        image[0..].each_with_index do |line, x|
          (0...line.size).each do |y|
            bytes = [
              image[x - 1][y - 1],
              image[x - 1][y],
              image[x - 1][y + 1] || this_padding_char,
              image[x][y - 1],
              image[x][y],
              image[x][y + 1] || this_padding_char,
              image[x + 1]&.at(y - 1) || this_padding_char,
              image[x + 1]&.at(y) || this_padding_char,
              image[x + 1]&.at(y + 1) || this_padding_char,
            ].join.gsub('#', '1').gsub('.', '0')
            compression_index = bytes.to_i 2
            new_image[x + 1][y + 1] = compression[compression_index]
          end
        end

        new_image
      end

      def apply_padding(image, padding_char, times = 1)
        new_image = []
        times.times do
          new_image << padding_char * (image[0].size + 2 * times)
        end
        image.each do |line|
          new_image << padding_char * times + line + padding_char * times
        end
        times.times do
          new_image << padding_char * (image[0].size + 2 * times)
        end

        new_image
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        compression, image = get_input.split("\n\n")
        [compression, apply_padding(image.split("\n"), '.', 2)]
      end

      def get_test_input(_number)
        <<~TEST
          ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

          #..#.
          #....
          ##..#
          ..#..
          ..###
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 20
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D20.new(test: false)
  today.run
end
