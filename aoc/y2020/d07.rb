require_relative '../solution'

module AoC
  module Y2020
    class D07 < Solution

      def part1
        input = parse_input

        input.keys.count { contains?(_1, 'shiny gold', input) }

      end

      def part2
        input = parse_input

        count_inside('shiny gold', input)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      memoize def contains?(outer, inner, rules)
        rules[outer].any? do |_count, content|
          content == inner || contains?(content, inner, rules)
        end
      end

      memoize def count_inside(outer, rules)
        rules[outer].sum do |count, content|
          count * (1 + count_inside(content, rules))
        end
      end

      private

      memoize def parse_input
        get_input.split("\n").to_h do |line|
          match = /^(.+) bags contain (.+)\.$/.match line
          bags = if match[2] == 'no other bags'
            []
          else
            match[2].split(', ').map do |part|
              m = part.match /^(\d+) (.+) bags?$/
              [m[1].to_i, m[2]]
            end
          end

          [match[1], bags]
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D07.new(test: test)
  today.run
end
