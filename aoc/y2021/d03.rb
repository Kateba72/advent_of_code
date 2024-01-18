require_relative '../solution'

module AoC
  module Y2021
    class D03 < Solution

      def part1
        input = parse_input
        half_entries = input.size / 2
        gamma = ''
        epsilon = ''
        (0...input[0].size).each do |col|
          if input.count { |line| line[col] == '1' } > half_entries
            gamma << '1'
            epsilon << '0'
          else
            gamma << '0'
            epsilon << '1'
          end
        end
        gamma.to_i(2) * epsilon.to_i(2)
      end

      def part2
        oxy_input = co2_input = parse_input

        current_bit = 0
        while oxy_input.size > 1
          ones = oxy_input.count { |line| line[current_bit] == '1' }
          correct_char = ones * 2 >= oxy_input.size ? '1' : '0'
          oxy_input = oxy_input.filter { |line| line[current_bit] == correct_char }
          current_bit += 1
        end

        current_bit = 0
        while co2_input.size > 1
          ones = co2_input.count { |line| line[current_bit] == '1' }
          correct_char = ones * 2 >= co2_input.size ? '0' : '1'
          co2_input = co2_input.filter { |line| line[current_bit] == correct_char }
          current_bit += 1
        end

        oxy_input.first.to_i(2) * co2_input.first.to_i(2)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D03.new(test: false)
  today.run
end
