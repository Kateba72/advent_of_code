require_relative '../solution'

module AoC
  module Y2022
    class D04 < Solution

      def part1
        input = parse_input
        input.count do |line|
          intersection = line[0] & line[1]
          intersection == line[0] || intersection == line[1]
        end
      end

      def part2
        input = parse_input
        input.count do |line|
          intersection = line[0] & line[1]
          intersection.size > 0
        end
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^(\d+)-(\d+),(\d+)-(\d+)$/)
          [(m[1].to_i)..m[2].to_i, m[3].to_i..m[4].to_i]
        end
      end

      def get_test_input(number)
        <<~TEST
          2-4,6-8
          2-3,4-5
          5-7,7-9
          2-8,3-7
          6-6,4-6
          2-6,4-8
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D04.new(test: false)
  today.run
end
