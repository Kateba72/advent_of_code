require_relative '../solution'

module AoC
  module Y2024
    class D02 < Solution

      def part1
        input = parse_input

        input.count do |line|
          safe? line
        end

      end

      def part2
        input = parse_input

        input.count do |line|
          (0..line.count).any? do |remove_index|
            l = line.dup
            l.delete_at remove_index
            safe?(l)
          end
        end
      end

      def safe?(line)
        line = line.reverse if line.first > line.second

        line.zip(line[1..]).all? { |x, y| y.nil? || (y - x).in?([1, 2, 3]) }
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map { _1.split.map(&:to_i) }
      end

      def get_test_input(number)
        <<~TEST
          7 6 4 2 1
          1 2 7 8 9
          9 7 6 2 1
          1 3 2 4 5
          8 6 4 4 1
          1 3 6 7 9
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2024::D02.new(test: false)
  today.run
end
