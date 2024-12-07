require_relative '../solution'

module AoC
  module Y2024
    class D07 < Solution

      def part1
        input = parse_input
        input.sum do |result, ints|
          (0..2**(ints.count-1)).any? do |i|
            r = ints.first
            ints[1..].each_with_index do |int, index|
              if i[index] == 1
                r += int
              else
                r *= int
              end
            end
            result == r
          end ? result : 0
        end
      end

      def part2
        input = parse_input
        input.sum do |result, ints|
          (0..3**(ints.count-1)).any? do |operands|
            operands = operands.to_s 3
            r = ints.first
            ints[1..].each_with_index do |i, index|
              if operands[-index-1] == '1'
                r += i
              elsif operands[-index-1] == '2'
                r *= i
              else
                r = (r.to_s + i.to_s).to_i
              end
              next if r > result
            end
            result == r
          end ? result : 0
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do
          i = _1.ints
          [i.shift, i]
        end
      end

      def get_test_input(number)
        <<~TEST
          190: 10 19
          3267: 81 40 27
          83: 17 5
          156: 15 6
          7290: 6 8 6 15
          161011: 16 10 13
          192: 17 8 14
          21037: 9 7 18 13
          292: 11 6 16 20
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D07.new(test: test)
  today.run

end
