require_relative '../solution'

module AoC
  module Y2020
    class D03 < Solution

      def part1
        input = parse_input
        check_slope(input, Vector[3, 1])
      end

      def part2
        input = parse_input

        slopes = [
          Vector[1, 1],
          Vector[3, 1],
          Vector[5, 1],
          Vector[7, 1],
          Vector[1, 2],
        ]

        slopes.reduce(1) do |result, slope|
          result * check_slope(input, slope)
        end
      end

      def check_slope(input, slope)
        pos = Vector[0, 0]
        count = 0
        while pos[1] < input.height
          count += 1 if input.at(pos) == '#'
          pos += slope
          pos[0] %= input.width
        end
        count
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input)
      end

      def get_test_input(_number)
        <<~TEST
          ..##.......
          #...#...#..
          .#....#..#.
          ..#.#...#.#
          .#...##..#.
          ..#.##.....
          .#.#.#....#
          .#........#
          #.##...#...
          #...##....#
          .#..#...#.#
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D03.new(test: test)
  today.run
end
