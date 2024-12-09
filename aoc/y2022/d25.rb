require_relative '../solution'

module AoC
  module Y2022
    class D25 < Solution

      def part1
        input = parse_input
        sum = input.sum do |line|
          to_decimal(line)
        end
        to_snafu(sum)
      end

      def to_decimal(snafu)
        sum = 0
        snafu_chars = { '2' => 2, '1' => 1, '0' => 0, '-' => -1, '=' => -2 }
        snafu.chars.reverse.each_with_index do |char, index|
          sum += snafu_chars[char] * 5**index
        end
        sum
      end

      def to_snafu(decimal)
        carry_over = 0
        snafu_digits = { 2 => '2', 1 => '1', 0 => '0', -1 => '-', -2 => '=' }
        reverse_snafu = decimal.to_s(5).chars.reverse.map do |char|
          digit = char.to_i + carry_over
          carry_over = 0
          if digit >= 3
            digit -= 5
            carry_over = 1
          end
          snafu_digits[digit]
        end
        reverse_snafu.append '1' if carry_over == 1
        reverse_snafu.reverse.join
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          1=-0-2
          12111
          2=0=
          21
          2=01
          111
          20012
          112
          1=-1=
          1-12
          12
          1=
          122
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 25
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D25.new(test: false)
  today.run
end
