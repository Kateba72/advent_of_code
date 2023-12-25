require_relative '../solution'

module AoC
  module Y2022
    class D11 < Solution

      def part1
        monkeys = parse_input.deep_dup

        monkey_counts = monkeys.map { 0 }

        20.times do
          monkeys.each_with_index do |monkey, index|
            monkey[:items].each do |item|
              monkey_counts[index] += 1
              old = item
              new_value = eval(monkey[:operation]) / 3

              next_monkey = (new_value % monkey[:test] == 0) ? monkey[:if_true] : monkey[:if_false]
              monkeys[next_monkey][:items].append new_value
            end
            monkey[:items] = []
          end
        end

        monkey_counts.sort.last(2).reduce(:*)
      end

      def part2
        monkeys = parse_input.deep_dup

        monkey_counts = monkeys.map { 0 }
        worry_level_factor = monkeys.map { |monkey| monkey[:test] }.reduce { |a, b| a * b / a.gcd(b) }

        10000.times do
          monkeys.each_with_index do |monkey, index|
            monkey[:items].each do |item|
              monkey_counts[index] += 1
              old = item
              new_value = eval(monkey[:operation]) % worry_level_factor

              next_monkey = (new_value % monkey[:test] == 0) ? monkey[:if_true] : monkey[:if_false]
              monkeys[next_monkey][:items].append new_value
            end
            monkey[:items] = []
          end
        end

        monkey_counts.sort.last(2).reduce(:*)
      end

      private

      memoize def parse_input
        monkeys = get_input.split("\n\n")
        monkeys.map do |monkey|
          items = monkey.match(/Starting items: ([0-9 ,]+)$/)[1].split(', ').map &:to_i
          operation = monkey.match(/Operation: new = (.+)$/)[1]
          test = monkey.match(/Test: divisible by (\d+)$/)[1].to_i
          if_true = monkey.match(/If true: throw to monkey (\d+)$/)[1].to_i
          if_false = monkey.match(/If false: throw to monkey (\d+)$/)[1].to_i
          { items:, operation:, test:, if_true:, if_false: }
        end
      end

      def get_test_input(number)
        <<~TEST
          Monkey 0:
            Starting items: 79, 98
            Operation: new = old * 19
            Test: divisible by 23
              If true: throw to monkey 2
              If false: throw to monkey 3

          Monkey 1:
            Starting items: 54, 65, 75, 74
            Operation: new = old + 6
            Test: divisible by 19
              If true: throw to monkey 2
              If false: throw to monkey 0

          Monkey 2:
            Starting items: 79, 60, 97
            Operation: new = old * old
            Test: divisible by 13
              If true: throw to monkey 1
              If false: throw to monkey 3

          Monkey 3:
            Starting items: 74
            Operation: new = old + 3
            Test: divisible by 17
              If true: throw to monkey 0
              If false: throw to monkey 1
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 11
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D11.new(test: false)
  today.run
end
