require_relative '../solution'

# https://adventofcode.com/2019/day/1
module AoC
  module Y2019
    class D01 < Solution

      def part1
        input = parse_input

        input.sum do |mass|
          mass / 3 - 2
        end
      end

      def part2
        input = parse_input

        input.sum do |mass|
          sum = 0
          while mass > 0
            mass = mass / 3 - 2
            sum += mass
          end

          sum - mass
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          100756
        TEST
      end

      AOC_YEAR = 2019
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2019::D01.new(test: test)
  today.run
end
