require_relative '../solution'

module AoC
  module Y2020
    class D02 < Solution

      def part1
        input = parse_input

        input.count do |line|
          c = line[3].count line[2]
          c.in? line[0]..line[1]
        end
      end

      def part2
        input = parse_input

        input.count do |line|
          (line[3][line[0]-1] == line[2]) ^ (line[3][line[1]-1] == line[2])
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match /(\d+)-(\d+) (\w): (\w+)/
          [m.captures[0].to_i, m.captures[1].to_i, m.captures[2], m.captures[3]]
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D02.new(test: false)
  today.run
end
