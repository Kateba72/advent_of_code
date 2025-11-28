require_relative '../solution'

# https://adventofcode.com/2019/day/4
module AoC
  module Y2019
    class D04 < Solution

      def part1
        min, max = parse_input
        count_possible_passwords(remaining_digits: 6, min: min.to_i, max: max.to_i, doubled: false)
      end

      def part2
        min, max = parse_input
        count_possible_passwords_2(remaining_digits: 6, min: min.to_i, max: max.to_i, doubled: false)
        pp @_memoized_count_possible_passwords_2
        count_possible_passwords_2(remaining_digits: 6, min: min.to_i, max: max.to_i, doubled: false)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def count_possible_passwords(remaining_digits:, min:, max:, doubled:, last_digit: nil)
        return 1 if remaining_digits == 0
        return 1 if remaining_digits == 1 && !doubled

        min_digit = min / 10 ** (remaining_digits - 1) if min
        max_digit = max / 10 ** (remaining_digits - 1) if max

        lowest = [min_digit, last_digit].compact.max
        highest = [max_digit, 9].compact.min

        (lowest..highest).sum do |digit|
          next_min = min % (10 ** (remaining_digits - 1)) if digit == min_digit
          next_max = max % (10 ** (remaining_digits - 1)) if max && digit == highest
          count_possible_passwords(
            remaining_digits: remaining_digits - 1,
            min: next_min,
            max: next_max,
            doubled: doubled || digit == last_digit,
            last_digit: digit,
          )
        end
      end

      memoize def count_possible_passwords_2(remaining_digits:, min:, max:, doubled:, last_digit: -1)
        return (doubled == true || doubled == :last_digit) ? 1 : 0 if remaining_digits == 0

        min_digit = min / 10 ** (remaining_digits - 1) if min
        max_digit = max / 10 ** (remaining_digits - 1) if max

        lowest = [min_digit, last_digit].compact.max
        highest = [max_digit, 9].compact.min

        (lowest..highest).sum do |digit|
          next_min = min % (10 ** (remaining_digits - 1)) if digit == min_digit
          next_max = max % (10 ** (remaining_digits - 1)) if max && digit == highest
          next_doubled = case doubled
          when true
            true
          when :last_digit
            digit == last_digit ? :not_this_digit : true
          when :not_this_digit
            digit == last_digit ? :not_this_digit : false
          when false
            digit == last_digit ? :last_digit : false
          end

          count_possible_passwords_2(
            remaining_digits: remaining_digits - 1,
            min: next_min,
            max: next_max,
            doubled: next_doubled,
            last_digit: digit
          )
        end
      end

      memoize def parse_input
        get_input.split("-")
      end

      def get_test_input(_number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2019
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2019::D04.new(test: test)
  today.run
end
