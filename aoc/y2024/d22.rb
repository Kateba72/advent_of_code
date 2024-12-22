require_relative '../solution'

# https://adventofcode.com/2024/day/22
module AoC
  module Y2024
    class D22 < Solution

      PRUNE = 16_777_216

      def part1
        input = parse_input

        input.sum do |secret|
          2000.times do
            secret = next_secret(secret)
          end
          secret
        end
      end

      def part2
        input = parse_input

        results = {}

        input.each_with_index do |secret, i|
          price_differences = []
          last_price = secret % 10
          2000.times do
            secret = next_secret(secret)
            price = secret % 10
            price_differences << price - last_price
            last_price = price

            next unless price_differences.size >= 4

            unless results[price_differences]&.at(i)
              results[price_differences] ||= []
              results[price_differences][i] = price
            end

            price_differences = price_differences[1..]
          end
        end

        results.values.map { |a| a.compact.sum }.max
      end

      def next_secret(secret)
        secret = ((secret << 6) ^ secret) % PRUNE
        secret = ((secret >> 5) ^ secret) % PRUNE
        ((secret << 11) ^ secret) % PRUNE
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          1
          2
          3
          2024
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 22
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D22.new(test: test)
  today.run
end
