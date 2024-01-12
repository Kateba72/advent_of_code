require_relative '../solution'

module AoC
  module Y2020
    class D18 < Solution

      def part1
        input = parse_input

        input.sum do |calculation|
          evaluate_expression(calculation, :evaluate_ltr)
        end
      end

      def part2
        input = parse_input

        input.sum do |calculation|
          evaluate_expression(calculation, :evaluate_sadmep)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      def evaluate_expression(calculation, evaluation_method)
        calculation = calculation.dup
        while calculation.include? '('
          calculation.gsub!(/\(([0-9 +*]+)\)/) do |subexpr|
            public_send(evaluation_method, Regexp.last_match[1])
          end
        end
        public_send(evaluation_method, calculation)
      end

      def evaluate_ltr(calculation)
        parts = calculation.split(' ')
        value = parts.shift.to_i
        parts.each_slice(2) do |expr, number|
          case expr
          when '+'
            value += number.to_i
          when '*'
            value *= number.to_i
          else
            raise "unknown expression #{expr}"
          end
        end
        value
      end

      def evaluate_sadmep(calculation)
        while calculation.include? '+'
          calculation.gsub!(/(\d+) \+ (\d+)/) do
            Regexp.last_match[1].to_i + Regexp.last_match[2].to_i
          end
        end
        while calculation.include? '*'
          calculation.gsub!(/(\d+) \* (\d+)/) do
            Regexp.last_match[1].to_i * Regexp.last_match[2].to_i
          end
        end
        calculation.to_i
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
5 + (8 * 3 + 9 + 3 * 4 * 3)
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 18
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D18.new(test: false)
  today.run
end
