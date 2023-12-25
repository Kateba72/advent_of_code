require_relative '../solution'

module AoC
  module Y2022
    class D06 < Solution

      def part1
        input = get_input
        start_marker input, 4
      end

      def part2
        input = get_input
        start_marker input, 14
      end

      private

      def start_marker(input, marker_size)
        ((marker_size-1)..).find do |i|
          Set.new(input[(i-marker_size+1)..i].chars).size == marker_size
        end + 1
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 6
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D06.new(test: false)
  today.run
end
