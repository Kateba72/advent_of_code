require_relative '../solution'

module AoC
  module Y2024
    class D07 < Solution

      def part1
        input = parse_input
        input.sum do |result, ints|
          possible?(result, ints, ints.size - 1, false) ? result : 0
        end
      end

      def part2
        input = parse_input
        input.sum do |result, ints|
          part2_info = ints.map do |i|
            [i.to_s, 10**i.to_s.size]
          end
          possible?(result, ints, ints.size - 1, part2_info) ? result : 0
        end
      end

      # To improve computation time for string concatenation, part2 is an array of [int[i].to_s, 10**int[i].to_s.size]
      def possible?(result, ints, index, part2)
        return result == ints.first if index == 0
        return false if result < ints[index]

        (part2 && result.to_s.end_with?(part2[index][0]) && possible?(result / part2[index][1], ints, index - 1, part2)) ||
          (result % ints[index] == 0 && possible?(result / ints[index], ints, index - 1, part2)) ||
          possible?(result - ints[index], ints, index - 1, part2)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do
          i = _1.ints
          [i.shift, i]
        end
      end

      def get_test_input(number)
        <<~TEST
          190: 10 19
          3267: 81 40 27
          83: 17 5
          156: 15 6
          7290: 6 8 6 15
          161011: 16 10 13
          192: 17 8 14
          21037: 9 7 18 13
          292: 11 6 16 20
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D07.new(test: test)
  today.run

end
