require_relative '../solution'

module AoC
  module Y2024
    class D04 < Solution

      def part1
        input = parse_input
        input.with_coords.sum do |letter, pos|
          next 0 unless letter == 'X'

          Grid2d::NEIGHBORS_WITH_DIAGONALS.count do |dir|
            input.at(pos + dir) == 'M' && input.at(pos + 2 * dir) == 'A' && input.at(pos + 3 * dir) == 'S'
          end
        end
      end

      def part2
        input = parse_input

        diagonals = (Grid2d::NEIGHBORS_WITH_DIAGONALS - Grid2d::NEIGHBORS).map do |dir|
          rot = Vector[dir[1], -dir[0]]
          [dir, rot]
        end

        input.with_coords.sum do |letter, pos|
          next 0 unless letter == 'A'

          diagonals.count do |dir, rot|
            input.at(pos - dir) == 'M' && input.at(pos + dir) == 'S' && input.at(pos - rot) == 'M' && input.at(pos + rot) == 'S'
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input)
      end

      def get_test_input(_number)
        <<~TEST
          MMMSXXMASM
          MSAMXMSMSA
          AMXSXMAAMM
          MSAMASMSMX
          XMASAMXAMM
          XXAMMXXAMA
          SMSMSASXSS
          SAXAMASAAA
          MAMMMXMMMM
          MXMXAXMASX
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2024::D04.new(test: false)
  today.run
end
