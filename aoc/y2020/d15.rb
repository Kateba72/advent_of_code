require_relative '../solution'

module AoC
  module Y2020
    class D15 < Solution

      def part1
        nth_number(2020, parse_input)
      end

      def part2
        nth_number(30_000_000, parse_input)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def nth_number(n, numbers)
        last_spoken = {}
        numbers.each_with_index do |number, index|
          last_spoken[number] = index
        end

        next_number = nil
        (numbers.size...n).each do |index|
          last_number = next_number
          next_number = if last_spoken[last_number]
            index - 1 - last_spoken[last_number]
          else
            0
          end
          last_spoken[last_number] = index - 1
        end

        next_number
      end

      memoize def parse_input
        get_input
      end

      def get_input
        if @test_input.present?
          @test_input
        elsif @test
          [0, 3, 6]
        else
          [9, 3, 1, 0, 8, 4]
        end
      end

      AOC_YEAR = 2020
      AOC_DAY = 15
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D15.new(test: false)
  today.run
end
