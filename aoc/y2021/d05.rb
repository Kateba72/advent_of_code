require_relative '../solution'

module AoC
  module Y2021
    class D05 < Solution

      def part1
        input = parse_input
        grid = []

        input.each do |line|
          if line[0] == line[2]
            Range.reversible(line[1], line[3]).each do |y|
              increment(grid, line[0], y)
            end
          elsif line[1] == line[3]
            Range.reversible(line[0], line[2]).each do |x|
              increment(grid, x, line[1])
            end
          end
        end

        grid.flatten.count { _1 && _1 >= 2 }
      end

      def part2
        input = parse_input
        grid = []

        input.each do |line|
          if line[0] == line[2]
            Range.reversible(line[1], line[3]).each do |y|
              increment(grid, line[0], y)
            end
          elsif line[1] == line[3]
            Range.reversible(line[0], line[2]).each do |x|
              increment(grid, x, line[1])
            end
          else
            Range.reversible(line[0], line[2]).zip(
              Range.reversible(line[1], line[3]),
            ).each do |x, y|
              increment(grid, x, y)
            end
          end
        end

        grid.flatten.count { _1 && _1 >= 2 }
      end

      def increment(grid, x, y)
        grid[y] ||= []
        grid[y][x] ||= 0
        grid[y][x] += 1
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^(\d+),(\d+) -> (\d+),(\d+)$/)
          m.captures.map(&:to_i)
        end
      end

      def get_test_input(_number)
        <<~TEST
          0,9 -> 5,9
          8,0 -> 0,8
          9,4 -> 3,4
          2,2 -> 2,1
          7,0 -> 7,4
          6,4 -> 2,0
          0,9 -> 2,9
          3,4 -> 1,4
          0,0 -> 8,8
          5,5 -> 8,2
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 5
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D05.new(test: false)
  today.run
end
