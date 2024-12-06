require_relative '../solution'

module AoC
  module Y2024
    class D06 < Solution

      def part1
        input = parse_input

        pos = (input.with_coords.find { _1[0] == '^' })[1]
        direction = Vector[0, -1]
        visited = Set.new

        while input.in_bounds?(pos)
          visited << pos
          while input.at(pos + direction) == '#'
            direction = Vector[-direction[1], direction[0]]
          end

          pos += direction
        end

        visited.size
      end

      def part2
        input = parse_input

        pos = (input.with_coords.find { _1[0] == '^' })[1]
        direction = Vector[0, -1]
        seen = Set.new
        visited = Set.new

        loop_count = 0

        while input.in_bounds?(pos)
          next_pos = pos + direction
          if input.at(next_pos) == '.' && seen.exclude?(next_pos)
            (loop_count += 1; p next_pos) if loop?(input, pos, direction, next_pos, visited)
          end

          seen << pos
          visited << [pos, direction]

          if input.at(next_pos) == '#'
            direction = Vector[-direction[1], direction[0]]
          else
            pos = next_pos
          end
        end

        loop_count
      end

      def loop?(input, pos, direction, additional, old_visited)
        visited = old_visited.dup

        while input.in_bounds?(pos)
          return true if visited.include?([pos, direction])

          visited << [pos, direction]

          while input.at(pos + direction) == '#' || (pos + direction) == additional
            direction = Vector[-direction[1], direction[0]]
          end

          pos += direction
        end

        false
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input)
      end

      def get_test_input(number)
        return <<~EDGECASES if number == 'EDGECASES'
          ..........
          ....#.....
          .....O..#.
          ..........
          ....^.....
          ...#......
          ....#..O..
          ..........
          ...#......
          ........O.
          ..#.......
          ......##..
          ..........
        EDGECASES
        <<~TEST
          ....#.....
          .........#
          ..........
          ..#.......
          .......#..
          ..........
          .#..^.....
          ........#.
          #.........
          ......#...
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 6
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D06.new(test: test)
  today.run
end
