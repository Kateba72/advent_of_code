require_relative '../solution'

# https://adventofcode.com/2024/day/15
module AoC
  module Y2024
    class D15 < Solution

      DIRECTIONS = {
        '<' => Grid2d::LEFT,
        '>' => Grid2d::RIGHT,
        'v' => Grid2d::DOWN,
        '^' => Grid2d::UP,
      }.freeze

      def part1
        map, directions = parse_input

        grid = Grid2d.from_string(map)
        robot = grid.with_coords.each { |ch, coords| break coords if ch == '@' }
        grid.set_at(robot, '.')

        directions.chars.each do |dir|
          dir = DIRECTIONS[dir]
          case grid.at(robot + dir)
          when '#'
            next
          when '.'
            robot += dir
          when 'O'
            move_to = calculate_move(grid, robot, dir)
            next unless move_to

            robot += dir
            grid.set_at(move_to, 'O')
            grid.set_at(robot, '.')
          end
        end

        score(grid)
      end

      def part2
        map, directions = parse_input

        map = map.gsub('.', '..').gsub('@', '@.').gsub('#', '##').gsub('O', '[]')
        grid = Grid2d.from_string(map)
        robot = grid.with_coords.each { |ch, coords| break coords if ch == '@' }
        grid.set_at(robot, '.')

        directions.chars.each do |dir|
          dir = DIRECTIONS[dir]
          case grid.at(robot + dir)
          when '#'
            next
          when '.'
            robot += dir
          when '['
            box = robot + dir
            if dir[0] == 0
              next unless move_possible_vert?(grid, box, dir)

              move_p2_vert(grid, box, dir)
            else
              next unless move_p2_right(grid, box)

              grid.set_at(box, '.')
            end
            robot = box
          when ']'
            if dir[0] == 0
              box = robot + dir + Vector[-1, 0]
              next unless move_possible_vert?(grid, box, dir)

              move_p2_vert(grid, box, dir)
            else
              box = robot + dir
              next unless move_p2_left(grid, box)

              grid.set_at(box, '.')
            end
            robot += dir
          end
        end

        score(grid)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def calculate_move(grid, robot, dir)
        box = robot + dir
        loop do
          check = box + dir
          case grid.at(check)
          when '#'
            return false
          when '.'
            return check
          when 'O'
            box = check
          end
        end
      end

      def move_possible_vert?(grid, box, dir)
        left_possible = case grid.at(box + dir)
        when '#'
          false
        when '.'
          true
        when '['
          move_possible_vert?(grid, box + dir, dir)
        when ']'
          move_possible_vert?(grid, box + dir + Vector[-1, 0], dir)
        end
        return false unless left_possible

        case grid.at(box + dir + Vector[1, 0])
        when '#'
          false
        when '.', ']' # ] was already tested in the branch before
          true
        when '['
          move_possible_vert?(grid, box + dir + Vector[1, 0], dir)
        end
      end

      def move_p2_vert(grid, box, dir)
        box_right = box + Vector[1, 0]
        grid.set_at(box, '.')
        grid.set_at(box + Vector[1, 0], '.')

        left = box + dir
        case grid.at(left)
        when '['
          move_p2_vert(grid, left, dir)
        when ']'
          move_p2_vert(grid, left + Vector[-1, 0], dir)
        end
        grid.set_at(left, '[')

        right = box_right + dir
        move_p2_vert(grid, right, dir) if grid.at(right) == '['
        grid.set_at(right, ']')
      end

      def move_p2_right(grid, box)
        next_space = box + Vector[2, 0]

        can_move = case grid.at(next_space)
        when '#'
          false
        when '.'
          true
        when '['
          move_p2_right(grid, next_space)
        end
        return false unless can_move

        grid.set_at(next_space, ']')
        grid.set_at(box + Vector[1, 0], '[')

        true
      end

      def move_p2_left(grid, box)
        next_space = box + Vector[-2, 0]

        can_move = case grid.at(next_space)
        when '#'
          false
        when '.'
          true
        when ']'
          move_p2_left(grid, next_space)
        end
        return false unless can_move

        grid.set_at(next_space, '[')
        grid.set_at(box + Vector[-1, 0], ']')

        true
      end

      def score(grid)
        grid.with_coords.sum do |ch, coords|
          next 0 unless ['O', '['].include? ch

          coords[0] + coords[1] * 100
        end
      end

      memoize def parse_input
        map, directions = get_input.split("\n\n")
        [map, directions.split.join]
      end

      def get_test_input(number)
        case number.to_s
        when '2'
          <<~TEST
            #######
            #...#.#
            #.....#
            #..OO@#
            #..O..#
            #.....#
            #######

            <vv<<^^<<^^
          TEST
        else
          <<~TEST
            ##########
            #..O..O.O#
            #......O.#
            #.OO..O.O#
            #..O@..O.#
            #O#..O...#
            #O..O..O.#
            #.OO.O.OO#
            #....O...#
            ##########

            <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
            vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
            ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
            <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
            ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
            ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
            >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
            <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
            ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
            v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
          TEST
        end
      end

      AOC_YEAR = 2024
      AOC_DAY = 15
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D15.new(test: test)
  today.run
end
