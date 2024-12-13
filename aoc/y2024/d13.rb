require_relative '../solution'

# https://adventofcode.com/2024/day/13
module AoC
  module Y2024
    class D13 < Solution

      def part1
        parse_input.sum { cost(_1) || 0 }
      end

      def part2
        parse_input.sum { cost(_1, part2: true) || 0 }
      end

      def cost(machine, part2: false)
        a, b, prize = machine
        prize += Vector[10_000_000_000_000, 10_000_000_000_000] if part2

        x = Vector[a[0], b[0], prize[0]]
        y = Vector[a[1], b[1], prize[1]]

        y *= a[0]
        y -= x * a[1]

        press_b = y[2].to_r / y[1]
        return nil if press_b < 0 || press_b.to_i != press_b

        prize -= press_b * b
        press_a = prize[0].to_r / a[0]
        return nil if press_a < 0 || press_a.to_i != press_a

        (3 * press_a + press_b).to_i
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n\n").map do |machine|
          a, b, prize = machine.split("\n").map(&:integers)
          [Vector[*a], Vector[*b], Vector[*prize]]
        end
      end

      def get_test_input(_number)
        <<~TEST
          Button A: X+94, Y+34
          Button B: X+22, Y+67
          Prize: X=8400, Y=5400

          Button A: X+26, Y+66
          Button B: X+67, Y+21
          Prize: X=12748, Y=12176

          Button A: X+17, Y+86
          Button B: X+84, Y+37
          Prize: X=7870, Y=6450

          Button A: X+69, Y+23
          Button B: X+27, Y+71
          Prize: X=18641, Y=10279
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 13
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D13.new(test: test)
  today.run
end
