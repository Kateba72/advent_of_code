require_relative '../solution'

# https://adventofcode.com/2020/day/25
module AoC
  module Y2020
    class D25 < Solution

      def part1
        input = parse_input

        loops = [nil, nil]

        subject_number = 7
        value = 1
        loop_count = 0
        until loops.all?
          loop_count += 1
          value = (value * subject_number) % 20_201_227
          loops[0] = loop_count if value == input[0]
          loops[1] = loop_count if value == input[1]
        end

        other_loops = loops.min
        subject_number = value
        value = 1
        other_loops.times do
          value = (value * subject_number) % 20_201_227
        end

        value
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
          5764801
          17807724
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 25
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D25.new(test: test)
  today.run
end
