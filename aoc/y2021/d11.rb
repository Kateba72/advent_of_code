require_relative '../solution'

# https://adventofcode.com/2021/day/11
module AoC
  module Y2021
    class D11 < Solution

      def part1
        input = parse_input.deep_dup

        (1..100).sum do |step|
          perform_step(input, step)
        end
      end

      def part2
        input = parse_input.deep_dup
        size = input.height * input.width

        (1..).find do |step|
          perform_step(input, step) == size
        end
      end

      def perform_step(grid, step)
        @flashes = 0
        grid.with_coords.each do |value, coords|
          increment(grid, coords, step, value)
        end
        @flashes
      end

      def increment(grid, coords, step, value = nil)
        value ||= grid.at(coords)
        return if value == -step || value.nil?

        value = 0 if value < 0
        value += 1

        if value >= 10
          grid.set_at(coords, -step)
          @flashes += 1

          Grid2d::NEIGHBORS_WITH_DIAGONALS.each do |direction|
            increment(grid, coords + direction, step)
          end
        else
          grid.set_at(coords, value)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input, &:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          5483143223
          2745854711
          5264556173
          6141336146
          6357385478
          4167524645
          2176841721
          6882881134
          4846848554
          5283751526
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 11
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2021::D11.new(test: test)
  today.run
end
