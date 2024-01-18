require_relative '../solution'

module AoC
  module Y2021
    class D02 < Solution

      def part1
        input = parse_input
        pos = input.sum(Vector[0, 0]) do |type, count|
          case type[0]
          when ?f
            Vector[count, 0]
          when ?d
            Vector[0, count]
          when ?u
            Vector[0, -count]
          end
        end
        pos[0] * pos[1]
      end

      def part2
        input = parse_input
        pos = Vector[0, 0]
        aim = 0
        input.each do |type, count|
          case type[0]
          when ?f
            pos += Vector[count, count * aim]
          when ?d
            aim += count
          when ?u
            aim -= count
          end
        end
        pos[0] * pos[1]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |instr|
          type, count = instr.split
          [type, count.to_i]
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D02.new(test: false)
  today.run
end
