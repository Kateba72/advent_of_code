require_relative '../solution'

module AoC
  module Y2024
    class D03 < Solution

      def part1
        input = parse_input

        input.enum_for(:scan, /mul\((\d+),(\d+)\)/).sum do
          Regexp.last_match[1].to_i * Regexp.last_match[2].to_i
        end
      end

      def part2
        input = parse_input
        enabled = true

        input.enum_for(:scan, /mul\((\d+),(\d+)\)|do\(\)|don't\(\)/).sum do
          if Regexp.last_match[0].start_with? "don't"
            enabled = false
            0
          elsif Regexp.last_match[0].start_with? "do"
            enabled = true
            0
          else
            enabled ? Regexp.last_match[1].to_i * Regexp.last_match[2].to_i : 0
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input
      end

      def get_test_input(number)
        <<~TEST
          xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2024::D03.new(test: false)
  today.run
end
