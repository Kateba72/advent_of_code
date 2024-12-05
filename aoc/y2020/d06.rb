require_relative '../solution'

module AoC
  module Y2020
    class D06 < Solution

      def part1
        input = parse_input

        input.sum do |lines|
          lines.gsub("\n", '').chars.uniq.size
        end

      end

      def part2
        input = parse_input

        input.sum do |lines|
          psg = lines.split("\n")
          psg[0].chars.count do |c|
            psg[1..].all? { _1.include? c}
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 6
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D06.new(test: test)
  today.run
end
