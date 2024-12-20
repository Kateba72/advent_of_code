require_relative '../solution'

# https://adventofcode.com/2024/day/19
module AoC
  module Y2024
    class D19 < Solution

      def part1
        towels, patterns = parse_input

        regexp = Regexp.new("^(#{towels.join('|')})+$")
        patterns.count { regexp.match? _1 }
      end

      def part2
        towels, patterns = parse_input

        patterns.sum { count_arrangements(_1, towels) }
      end

      memoize def count_arrangements(pattern, towels)
        towels.sum do |towel|
          if pattern == towel
            1
          elsif pattern.start_with? towel
            count_arrangements(pattern[towel.size..], towels)
          else
            0
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        towels, patterns = get_input.split("\n\n")
        towels = towels.split(', ')
        patterns = patterns.split("\n")
        [towels, patterns]
      end

      def get_test_input(_number)
        <<~TEST
          r, wr, b, g, bwu, rb, gb, br

          brwrr
          bggr
          gbbr
          rrbgbr
          ubwu
          bwurrg
          brgr
          bbrgwb
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 19
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D19.new(test: test)
  today.run
end
