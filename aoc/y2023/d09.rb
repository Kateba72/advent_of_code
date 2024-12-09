# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D09 < Solution

      def part1
        input = get_input

        input.sum do |line|
          interpolated = interpolate(line)
          extrapolate_next(interpolated)
        end
      end

      memoize def interpolate(line)
        interpolated = [line]
        until line.all? { |x| x == 0 }
          interpolated << line[1..].map.with_index do |value, index|
            value - line[index]
          end
          line = interpolated.last
        end
        interpolated
      end

      def extrapolate_next(interpolated)
        interpolated.sum(&:last)
      end

      def extrapolate_previous(interpolated)
        interpolated.map.with_index do |value, index|
          value.first * (index.even? ? 1 : -1)
        end.sum
      end

      def part2
        input = get_input

        input.sum do |line|
          interpolated = interpolate(line)
          extrapolate_previous(interpolated)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n").map do |line|
          line.split.map(&:to_i)
        end
      end

      def get_test_input(_number)
        <<~TEST
          10 13 16 21 30 45
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 9
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D09.new(test: false)
  today.run
end
