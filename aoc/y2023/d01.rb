require_relative '../solution'

module AoC
  module Y2023
    class D01 < Solution

      NUMBERS_WITH_LETTERS = {
        'one' => 1,
        'two' => 2,
        'three' => 3,
        'four' => 4,
        'five' => 5,
        'six' => 6,
        'seven' => 7,
        'eight' => 8,
        'nine' => 9
      }

      def part1
        input = parse_input

        input.sum do |line|
          first = line.match(/\d/).to_s.to_i
          last = line.reverse.match(/\d/).to_s.to_i
          first * 10 + last
        end

      end

      def part2
        input = parse_input
        input.sum do |line|
          first = line.match(/(\d|one|two|three|four|five|six|seven|eight|nine)/).to_s
          first = str_to_i(first)
          last = line.reverse.match(/(\d|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno)/).to_s
          last = str_to_i(last.reverse)
          first * 10 + last
        end
      end

      def str_to_i(str)
        NUMBERS_WITH_LETTERS[str] || str.to_i
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        case number
        when 1
          <<~TEST
            1abc2
            pqr3stu8vwx
            a1b2c3d4e5f
            treb7uchet
          TEST
        when 2
          <<~TEST
            two1nine
            eightwothree
            abcone2threexyz
            xtwone3four
            4nineeightseven2
            zoneight234
            7pqrstsixteen
          TEST
        end
      end

      AOC_YEAR = 2023
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D01.new(test: false)
  today.run
end
