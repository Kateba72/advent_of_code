require_relative '../solution'

# https://adventofcode.com/2024/day/21
module AoC
  module Y2024
    class D21 < Solution

      DOOR = {
        '7' => Vector[-2, -3],
        '8' => Vector[-1, -3],
        '9' => Vector[0, -3],
        '4' => Vector[-2, -2],
        '5' => Vector[-1, -2],
        '6' => Vector[0, -2],
        '1' => Vector[-2, -1],
        '2' => Vector[-1, -1],
        '3' => Vector[0, -1],
        '0' => Vector[-1, 0],
        'A' => Vector[0, 0],
        panic: Vector[-2, 0],
      }.freeze

      ROBOT = {
        'A' => Vector[0, 0],
        '^' => Vector[-1, 0],
        '>' => Vector[0, 1],
        'v' => Vector[-1, 1],
        '<' => Vector[-2, 1],
        panic: Vector[-2, 0],
      }.freeze

      def part1
        input = parse_input

        input.sum do |code|
          current_vec = DOOR['A']
          code.integers[0] * code.chars.sum do |ch|
            r = shortest_code(DOOR[ch] - current_vec, DOOR[:panic] - current_vec, 2)
            current_vec = DOOR[ch]
            r
          end
        end
      end

      memoize def shortest_code(direction, panic_direction, robot_levels)
        return direction.manhattan(Vector[0, 0]) + 1 if robot_levels == 0

        horizontals = [direction[0] > 0 ? '>' : '<'] * direction[0].abs
        verticals = [direction[1] > 0 ? 'v' : '^'] * direction[1].abs
        possibilities = []

        possibilities << [*horizontals, *verticals, 'A'] unless direction[0] == panic_direction[0] && direction[1] * panic_direction[1] >= 0
        possibilities << [*verticals, *horizontals, 'A'] unless direction[1] == panic_direction[1] && direction[0] * panic_direction[0] >= 0

        needed_presses = possibilities.map do |keypresses|
          current_vec = ROBOT['A']
          keypresses.sum do |key|
            r = shortest_code(ROBOT[key] - current_vec, ROBOT[:panic] - current_vec, robot_levels - 1)
            current_vec = ROBOT[key]
            r
          end
        end

        needed_presses.min
      end

      # for debugging purposes
      def decode(keypresses, keypad)
        current_vec = Vector[0, 0]
        result_keypresses = []
        keypad = keypad.invert
        directions = { '>' => Vector[1, 0], '<' => Vector[-1, 0], 'v' => Vector[0, 1], '^' => Vector[0, -1] }.freeze

        keypresses.chars.each do |key|
          if key == 'A'
            result_keypresses << keypad[current_vec]
          else
            current_vec += directions[key]
          end

          if keypad[current_vec].in? [nil, :panic]
            result_keypresses << 'PANIC'
            return result_keypresses.join
          end
        end

        result_keypresses.join
      end

      def part2
        input = parse_input

        input.sum do |code|
          current_vec = DOOR['A']
          code.integers[0] * code.chars.sum do |ch|
            r = shortest_code(DOOR[ch] - current_vec, DOOR[:panic] - current_vec, 25)
            current_vec = DOOR[ch]
            r
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          029A
          980A
          179A
          456A
          379A
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 21
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D21.new(test: test)
  today.run
end
