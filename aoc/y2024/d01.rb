require_relative '../solution'

module AoC
  module Y2024
    class D01 < Solution

      def part1
        lists = parse_input

        lists[0].sort.zip(lists[1].sort).sum do |x, y|
          x < y ? y - x : x - y
        end
      end

      def part2
        lists = parse_input

        lists[0].sum do |x|
          x * lists[1].count(x)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        lists = get_input.split("\n").map do |line|
          line.strip.split.map(&:to_i)
        end
        firsts = lists.map(&:first)
        seconds = lists.map(&:second)
        [firsts, seconds]
      end

      def get_test_input(_number)
        <<~TEST
          3   4
          4   3
          2   5
          1   3
          3   9
          3   3
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2024::D01.new(test: false)
  today.run
end
