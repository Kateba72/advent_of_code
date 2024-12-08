require_relative '../solution'

module AoC
  module Y2020
    class D05 < Solution

      def part1
        input = parse_input

        input.map do |line|
          binary = line.gsub('F', '0').gsub('B', '1').gsub('L', '0').gsub('R', '1')
          binary.to_i 2
        end.max
      end

      def part2
        input = parse_input
        seats = input.map do |line|
          binary = line.gsub('F', '0').gsub('B', '1').gsub('L', '0').gsub('R', '1')
          binary.to_i 2
        end
        (seats.min..seats.max).find do |seat|
          seats.exclude? seat
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        # There is no good test input
      end

      AOC_YEAR = 2020
      AOC_DAY = 5
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D05.new(test: test)
  today.run
end
