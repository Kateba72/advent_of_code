require_relative '../solution'

module AoC
  module Y2021
    class D14 < Solution

      def part1
        template, rules = parse_input

        pairs = Hash.new(0)
        template.each_with_index do |ch, i|
          if template[i + 1]
            pair = ch + template[i + 1]
            pairs[pair] += 1
          end
        end

        10.times do
          pairs = apply_rules(pairs, rules)
        end

        counts = Hash.new(0)
        pairs.each do |pair, count|
          counts[pair[0]] += count
        end
        counts[template[-1]] += 1

        counts.values.max - counts.values.min
      end

      def part2
        template, rules = parse_input

        pairs = Hash.new(0)
        template.each_with_index do |ch, i|
          if template[i + 1]
            pair = ch + template[i + 1]
            pairs[pair] += 1
          end
        end

        40.times do
          pairs = apply_rules(pairs, rules)
        end

        counts = Hash.new(0)
        pairs.each do |pair, count|
          counts[pair[0]] += count
        end
        counts[template[-1]] += 1

        counts.values.max - counts.values.min
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def apply_rules(pairs, rules)
        output_pairs = Hash.new(0)
        pairs.each do |pair, count|
          middle_char = rules[pair]
          output_pairs[pair[0] + middle_char] += count
          output_pairs[middle_char + pair[1]] += count
        end
        output_pairs
      end

      def parse_input
        template, rules = get_input.split("\n\n")

        rules = rules.split("\n").to_h do |rule|
          if (m = rule.match(/([A-Z][A-Z]) -> ([A-Z])/))
            [m[1], m[2]]
          else
            throw "Invalid rule #{rule}"
          end
        end
        [template.chars, rules]
      end

      def get_test_input(_number)
        <<~TEST
          NNCB

          CH -> B
          HH -> N
          CB -> H
          NH -> C
          HB -> C
          HC -> B
          HN -> C
          NN -> C
          BH -> H
          NC -> B
          NB -> B
          BN -> B
          BB -> N
          BC -> B
          CC -> N
          CN -> C
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 14
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D14.new(test: false)
  today.run
end
