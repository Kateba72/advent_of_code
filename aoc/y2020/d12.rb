require_relative '../solution'

module AoC
  module Y2020
    class D12 < Solution

      def part1
        input = parse_input

        ship_pos = Vector[0, 0]
        direction = Vector[1, 0]

        input.each do |line|
          action = line[0]
          amount = line[1..].to_i
          case action
          when 'N'
            ship_pos[1] += amount
          when 'S'
            ship_pos[1] -= amount
          when 'E'
            ship_pos[0] += amount
          when 'W'
            ship_pos[0] -= amount
          when 'L'
            direction = rotate_direction(direction, amount)
          when 'R'
            direction = rotate_direction(direction, -amount)
          when 'F'
            ship_pos += amount * direction
          end
        end

        ship_pos.map(&:abs).sum.to_i
      end

      def part2
        input = parse_input

        ship_pos = Vector[0, 0]
        direction = Vector[10, 1]

        input.each do |line|
          action = line[0]
          amount = line[1..].to_i
          case action
          when 'N'
            direction[1] += amount
          when 'S'
            direction[1] -= amount
          when 'E'
            direction[0] += amount
          when 'W'
            direction[0] -= amount
          when 'L'
            direction = rotate_direction(direction, amount)
          when 'R'
            direction = rotate_direction(direction, -amount)
          when 'F'
            ship_pos += amount * direction
          end
        end

        ship_pos.map(&:abs).sum.to_i
      end

      def rotate_direction(direction, amount)
        rotation = Matrix[[0, -1], [1, 0]]
        (rotation**(amount / 90)) * direction
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
          F10
          N3
          F7
          R90
          F11
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D12.new(test: false)
  today.run
end
