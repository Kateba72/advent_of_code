require_relative '../solution'

module AoC
  module Y2020
    class D09 < Solution

      memoize def part1
        input = parse_input

        input[@length..].each_with_index.find do |sum, is|
          input[is...is+@length].each_with_index.none? do |s1, i1|
            input[is+i1...is+@length].any? { |s2| s1 + s2 == sum }
          end
        end[0]

      end

      def part2
        input = parse_input
        invalid = part1

        range = input.each_index.each do |i_start|
          sum = input[i_start]
          i_end = (i_start + 1..).each do |i_next|
            sum += input[i_next]
            break i_next if sum >= invalid
          end

          break i_start..i_end if sum == invalid
        end

        slice = input[range]
        slice.min + slice.max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
        @length = testing? ? 5 : 25
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(number)
        <<~TEST
          35
          20
          15
          25
          47
          40
          62
          55
          65
          95
          102
          117
          150
          182
          127
          219
          299
          277
          309
          576
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 9
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D09.new(test: test)
  today.run
end
