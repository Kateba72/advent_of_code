require_relative '../solution'

module AoC
  module Y2020
    class D01 < Solution

      def part1
        input = parse_input
        numbers = input.to_set

        match = input.find do |i|
          numbers.include?(2020 - i)
        end

        match * (2020 - match)
      end

      def part2
        input = parse_input
        numbers = input.to_set

        match1, match2 = input.product(input).find do |i, j|
          numbers.include? (2020 - i - j)
        end
        match1 * match2 * (2020 - match1 - match2)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D01.new(test: false)
  today.run
end
