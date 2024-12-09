require_relative '../solution'

module AoC
  module Y2022
    class D09 < Solution

      def part1
        steps = parse_input
        visited = Set.new
        knots = [Vector[0, 0]] * 2
        visited.add(knots.last)

        steps.each do |step|
          step[1].times do
            knots = move(knots, step[0])
            visited.add(knots.last)
          end
        end

        visited.size
      end

      def part2
        steps = parse_input
        visited = Set.new
        knots = [Vector[0, 0]] * 10
        visited.add(knots.last)

        steps.each do |step|
          step[1].times do
            knots = move(knots, step[0])
            visited.add(knots.last)
          end
        end

        visited.size
      end

      private

      def move(knots, movement)
        case movement
        when 'U'
          knots[0] += Vector[0, 1]
        when 'D'
          knots[0] += Vector[0, -1]
        when 'L'
          knots[0] += Vector[-1, 0]
        when 'R'
          knots[0] += Vector[1, 0]
        end

        (0...knots.size - 1).each do |index|
          difference = knots[index].p_norm_to_p(knots[index + 1], 2)

          next unless difference >= 4

          knots[index + 1] += (knots[index] - knots[index + 1]).map do |element|
            if element >= 1
              1
            else
              [element, -1].max
            end
          end
        end

        knots
      end

      memoize def parse_input
        get_input.split("\n").map do |line|
          [line[0], line[2..].to_i]
        end
      end

      def get_test_input(_number)
        <<~TEST
          R 4
          U 4
          L 3
          D 1
          R 4
          D 1
          L 5
          R 2
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 9
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D09.new(test: false)
  today.run
end
