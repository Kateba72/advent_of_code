require_relative '../solution'

# https://adventofcode.com/💙year💙/day/💙day_nlz💙
module AoC
  module Y💙year💙
    class D💙day💙 < Solution

      def part1
        input = parse_input

      end

      def part2
        input = parse_input
        'Not Implemented'
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
        <<~TEST
        TEST
      end

      AOC_YEAR = 💙year💙
      AOC_DAY = 💙day_nlz💙
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y💙year💙::D💙day💙.new(test: test)
  today.run
end
