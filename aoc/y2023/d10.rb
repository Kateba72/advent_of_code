require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D10 < Solution

      def part1
        input = get_input
        start, direction = find_start(input)
        point = start
        loop_size = (0..).each do |i|
          break i if point == start && i > 0
          point, direction = traverse(point, direction, input)
        end
        loop_size / 2
      end

      def part2
        input = get_input
        start, direction = find_start(input)
        point = start

        (0..).each do |i|
          break i if point == start && i > 0
          point, next_direction = traverse(point, direction, input)

          if direction == 4 || next_direction == 1
            input[point[0]][point[1]] = '!'
          else
            input[point[0]][point[1]] = '_'
          end

          direction = next_direction
        end

        input.sum do |line|
          subbed = line.gsub('_', '').gsub('!!', '')
          inside = false
          inside_count = 0
          subbed.each_char do |c|
            if c == '!'
              inside = !inside
            elsif inside
              inside_count += 1
            end
          end
          raise "#{line.inspect} -> #{subbed.inspect} stays inside" if inside
          inside_count
        end
      end

      memoize def find_start(input)
        sy = input.find_index do |line|
          line.index 'S'
        end
        sx = input[sy].index('S')
        start = Vector[sy, sx]

        # directions are 1: up, 2: left, 3: right: 4 down
        # In the original code I just said "direction = 1" by looking at the input, but this seems more appropriate
        # (still doesn't account for S on the edge on the board, but I hope this is not needed)
        direction = if %w[7 | F].include? input[start[0] - 1][start[1]]
          1
        elsif %w[F - L].include? input[start[0]][start[1] - 1]
          2
        else
          3 # the S pipe has to connect to two directions.
        end
        [start, direction]
      end

      def traverse(point, direction, input)
        case direction
        when 1
          point += Vector[-1, 0]
          case input[point[0]][point[1]]
          when '7'
            direction = 2
          when 'F'
            direction = 3
          end
        when 2
          point += Vector[0, -1]
          case input[point[0]][point[1]]
          when 'L'
            direction = 1
          when 'F'
            direction = 4
          end
        when 3
          point += Vector[0, 1]
          case input[point[0]][point[1]]
          when 'J'
            direction = 1
          when '7'
            direction = 4
          end
        when 4
          point += Vector[1, 0]
          case input[point[0]][point[1]]
          when 'L'
            direction = 3
          when 'J'
            direction = 2
          end
        end
        [point, direction]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 10
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D10.new(test: false)
  today.run
end
