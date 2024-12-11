require_relative '../solution'

# https://adventofcode.com/2024/day/11
module AoC
  module Y2024
    class D11 < Solution

      def part1
        stones = parse_input

        stones.sum do |stone|
          blink_count(stone, 25)
        end
      end

      def part2
        stones = parse_input

        stones.sum do |stone|
          blink_count(stone, 75)
        end
      end

      memoize def blink_count(stone, times)
        if times == 0
          1
        elsif stone == 0
          blink_count(1, times - 1)
        elsif (str = stone.to_s).size.even?
          blink_count(str[0...str.size / 2].to_i, times - 1) + blink_count(str[str.size / 2..].to_i, times - 1)
        else
          blink_count(stone * 2024, times - 1)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split.map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          125 17
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 11
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D11.new(test: test)
  today.run
end
