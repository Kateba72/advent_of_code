require_relative '../solution'

module AoC
  module Y2020
    class D10 < Solution

      def part1
        input = parse_input

        sorted = input.sort
        sorted.unshift 0
        sorted << sorted.last + 3

        differences = sorted.zip(sorted[1..]).map { |a, b| b && b - a }

        differences.count(1) * differences.count(3)
      end

      def part2
        input = parse_input

        sorted = input.sort
        sorted.unshift 0
        sorted << sorted.last + 3

        differences = sorted.zip(sorted[1..]).map { |a, b| b && b - a }.compact

        parts = differences.split(3)

        parts.map { calculate_options(_1) }.multiply
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      memoize def calculate_options(part)
        return 1 if part.size <= 1

        sum = 0
        real = part.map do |diff|
          sum += diff
        end
        real.sort!
        max = real.pop

        (0..real.length).map do
          real.combination(_1).to_a
        end.flatten(1).filter do |comb|
          comb << max
          next if comb.min > 3
          next if comb.zip(comb[1..]).map { |a, b| b && b - a }.compact.any? { _1 > 3}
          true
        end.count
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 10
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D10.new(test: test)
  today.run
end
