require_relative '../solution'

module AoC
  module Y2024
    class D05 < Solution

      def part1
        rules, lines = parse_input

        lines.filter do |line|
          rules.all? do |rule|
            (line.index(rule[0]) || -1) < (line.index(rule[1]) || line.size)
          end
        end.sum do |line|
          line[line.size / 2].to_i
        end

      end

      def part2
        rules, lines = parse_input

        assert_all_rules(rules)

        lines.filter_map do |line|
          sorted = sort_line(line, rules)
          next if sorted == line
          sorted
        end.sum do |line|
          line[line.size / 2].to_i
        end
      end

      def sort_line(line, rules)
        line.sort do |p1, p2|
          if rules.include?([p1, p2])
            -1
          else
            1
          end
        end
      end

      def assert_all_rules(rules)
        all_pages = rules.to_a.flatten.uniq.size
        raise 'Not all rules present' unless rules.size == all_pages * (all_pages - 1) / 2
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        rules, lines = get_input.split("\n\n")
        rules = rules.split("\n").map { _1.split('|') }.to_set
        lines = lines.split("\n").map { _1.split ',' }
        [rules, lines]
      end

      def get_test_input(number)
        <<~TEST
          47|53
          97|13
          97|61
          97|47
          75|29
          61|13
          75|53
          29|13
          97|29
          53|29
          61|53
          97|53
          61|29
          47|13
          75|47
          97|75
          47|61
          75|61
          47|29
          75|13
          53|13

          75,47,61,53,29
          97,61,53,29,13
          75,29,13
          75,97,47,61,53
          61,13,29
          97,13,75,29,47
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 5
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D05.new(test: test)
  today.run
end
