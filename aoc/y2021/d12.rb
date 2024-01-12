require_relative '../solution'

module AoC
  module Y2021
    class D12 < Solution

      def part1
        input = parse_input

      end

      def part2
        input = parse_input
        'Not Implemented'
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D12.new(test: false)
  today.run
end
