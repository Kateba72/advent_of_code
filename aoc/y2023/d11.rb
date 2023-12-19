require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D11 < Solution

      def part1
        galaxies = get_input

        galaxies.sum do |gala|
          galaxies.sum do |galb|
            distance(gala, galb)
          end
        end / 2

      end

      def part2
        galaxies = get_input

        galaxies.sum do |gala|
          galaxies.sum do |galb|
            distance(gala, galb,999_999) # 999_999 additional rows plus the 1 row that already exists equals 1_000_000
          end
        end / 2
      end

      def distance(gala, galb, expansion = 1)
        len = gala.manhattan(galb)
        rcol = gala[0] < galb[0] ? gala[0]...galb[0] : galb[0]...gala[0]
        len += expansion * @empty_columns.count do |col|
          rcol.cover? col
        end
        rrow = gala[1] < galb[1] ? gala[1]...galb[1] : galb[1]...gala[1]
        len += expansion * @empty_rows.count do |row|
          rrow.cover? row
        end
        len
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        input = super.split("\n")
        @empty_rows = input.filter_map.with_index do |line, index|
          line.count('#') == 0 ? index : nil
        end
        @empty_columns = (0...input[0].size).filter do |column|
          input.all? { |row| row[column] == '.' }
        end
        galaxies = input.map.with_index do |line, y|
          line.chars.filter_map.with_index do |char, x|
            char == '#' ? Vector[x, y] : nil
          end
        end.flatten
        galaxies
      end

      def get_test_input(number)
        <<~TEST
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 11
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D11.new(test: false)
  today.run
end
