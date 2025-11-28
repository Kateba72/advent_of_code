require_relative '../solution'

# https://adventofcode.com/2019/day/3
module AoC
  module Y2019
    class D03 < Solution

      def both_parts
        wire_a, wire_b = parse_input

        wire_a_visited = {}

        origin = Vector[0, 0]
        pos = origin
        wire_length = 0
        wire_a.each do |direction, magnitude|
          magnitude.times do
            pos += direction
            wire_length += 1
            wire_a_visited[pos] = wire_length
          end
        end

        pos = origin
        nearest = wire_length
        least_combined_length = wire_length * 3

        wire_length = 0
        wire_b.each do |direction, magnitude|
          magnitude.times do
            pos += direction
            wire_length += 1

            if wire_a_visited[pos] && pos != origin
              distance = pos.manhattan(origin)
              nearest = distance if distance < nearest

              combined_length = wire_length + wire_a_visited[pos]
              least_combined_length = combined_length if combined_length < least_combined_length
            end
          end
        end

        [nearest, least_combined_length]
      end

      def part2
        input = parse_input
        'Not Implemented'
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |wire|
          wire.split(',').map do |instruction|
            direction = instruction[0]
            magnitude = instruction[1..].to_i
            direction = case direction
            when 'R'
              Vector[1, 0]
            when 'L'
              Vector[-1, 0]
            when 'U'
              Vector[0, 1]
            when 'D'
              Vector[0, -1]
            end
            [direction, magnitude]
          end
        end
      end

      def get_test_input(number)
        [<<~FIRST, <<~SECOND, <<~THIRD][number.is_a?(String) ? number.to_i : 0]
          R8,U5,L5,D3
          U7,R6,D4,L4
        FIRST
          R75,D30,R83,U83,L12,D49,R71,U7,L72
          U62,R66,U55,R34,D71,R55,D58,R83
        SECOND
          R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
          U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
        THIRD
      end

      AOC_YEAR = 2019
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2019::D03.new(test: test)
  today.run
end
