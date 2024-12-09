require_relative '../solution'

module AoC
  module Y2020
    class D19 < Solution

      def part1
        texts = parse_input

        texts.count do |text|
          text.size == get_length('0') && match(text.chars, '0')
        end
      end

      memoize def match(text, rule_no)
        rule = @rules[rule_no]
        if rule[0]
          text[0] == rule[0]
        else
          rule[1].any? do |rulepart|
            offset = 0
            rulepart.all? do |part|
              length = get_length(part)
              matches = match(text[offset...(offset + length)], part)
              offset += length
              matches
            end
          end
        end
      end

      memoize def get_length(rule_no)
        rule = @rules[rule_no]
        lengths = if rule[0]
          [1]
        else
          rule[1].map do |rulepart|
            rulepart.sum do |part|
              get_length(part)
            end
          end
        end

        raise "rule #{rule} has lengths #{lengths}" if lengths.uniq.size >= 2

        lengths[0]
      end

      def part2
        texts = parse_input
        # Rule 8 and 11 are only used in rule 0, which is "8 11"
        # So a match now roughly equals 42 [42 ...] 42 31 [31 ...]
        # where the number of additional 42s must be greater or equal than the number of additional 31s
        # Both rules 42 and 31 have the same length
        chunk_size = get_length('42')
        raise unless get_length('31') == chunk_size

        texts.count do |text|
          next false unless text.size % chunk_size == 0

          forced_42_chunks = ((text.size / chunk_size) / 2 + 1).to_i
          switched_to_31 = false
          text.chars.in_chunks(chunk_size).with_index.all? do |chunk, index|
            if index < forced_42_chunks
              match(chunk, '42')
            elsif switched_to_31 || index == text.size / chunk_size - 1
              match(chunk, '31')
            elsif match(chunk, '42')
              true
            else
              switched_to_31 = true
              match(chunk, '31')
            end
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        rules, texts = get_input.split("\n\n").map { |x| x.split("\n") }
        @rules = rules.to_h do |line|
          no, parts = line.split(': ')
          is_single = parts.match?(/^"[ab]"$/) ? parts[1] : false
          [no, [is_single, parts.split(' | ').map(&:split)]]
        end
        texts
      end

      def get_test_input(_number)
        <<~TEST
          0: 4 1 5
          1: 2 3 | 3 2
          2: 4 4 | 5 5
          3: 4 5 | 5 4
          4: "a"
          5: "b"

          ababbb
          bababa
          abbbab
          aaabbb
          aaaabbb
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 19
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D19.new(test: false)
  today.run
end
