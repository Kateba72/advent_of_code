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
              m = part.match(/^(\d+) (.+) bags?$/)
              [m[1].to_i, m[2]]
            end
          end

          [match[1], bags]
        end
      end

      def get_test_input(number)
        number == 2 ? <<~TEST2 : <<~TEST1
          shiny gold bags contain 2 dark red bags.
          dark red bags contain 2 dark orange bags.
          dark orange bags contain 2 dark yellow bags.
          dark yellow bags contain 2 dark green bags.
          dark green bags contain 2 dark blue bags.
          dark blue bags contain 2 dark violet bags.
          dark violet bags contain no other bags.
        TEST2
          light red bags contain 1 bright white bag, 2 muted yellow bags.
          dark orange bags contain 3 bright white bags, 4 muted yellow bags.
          bright white bags contain 1 shiny gold bag.
          muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
          shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
          dark olive bags contain 3 faded blue bags, 4 dotted black bags.
          vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
          faded blue bags contain no other bags.
          dotted black bags contain no other bags.
        TEST1
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
