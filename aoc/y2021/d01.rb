require_relative '../solution'

module AoC
  module Y2021
    class D01 < Solution

      def part1
        input = parse_input
        (1...input.size).count do |i|
          input[i - 1] < input[i]
        end
      end

      def part2
        input = parse_input
        (1...input.size).count do |i|
          input[i - 3] < input[i]
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
          199
          200
          208
          210
          200
          207
          240
          269
          260
          263
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D01.new(test: false)
  today.run
end
