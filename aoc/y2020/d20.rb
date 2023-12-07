require 'matrix'
require_relative '../base_class'

module AoC
  module Y2020
    class D20 < BaseClass

      def part1
        input = get_input
        edges = Hash.new

        input.each do |tileno, tile|
          [tile.row(0), tile.column(0), tile.row(tile.row_count - 1), tile.column(tile.column_count - 1)].each do |edge|
            edge = edge.to_a
            edge = edge.reverse if (edge <=> edge.reverse) == -1
            edges[edge] ||= []
            edges[edge] << tileno
          end
        end

        edge_pieces = edges.values.filter_map do | tiles|
          raise 'ambiguous' if tiles.count >= 3
          tiles.count == 2 ? nil : tiles
        end.compact.flatten

        corner_pieces = edge_pieces.filter { |p| edge_pieces.count(p) > 1 }
        corner_pieces.uniq.inject(&:*)
      end

      def part2
        input = get_input
        'Not Implemented'
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n\n").to_h do |tile|
          lines = tile.split("\n")
          tileno = lines[0].ints[0]
          matrix = lines[1..].map do |line|
            line.chars.map do |char|
              char == '#' ? 1 : 0
            end
          end
          [tileno, Matrix[*matrix]]
        end
      end

      def get_test_input(number)
        <<~TEST
          Tile 2311:
          ..##.#..#.
          ##..#.....
          #...##..#.
          ####.#...#
          ##.##.###.
          ##...#.###
          .#.#.#..##
          ..#....#..
          ###...#.#.
          ..###..###

          Tile 1951:
          #.##...##.
          #.####...#
          .....#..##
          #...######
          .##.#....#
          .###.#####
          ###.##.##.
          .###....#.
          ..#.#..#.#
          #...##.#..

          Tile 1171:
          ####...##.
          #..##.#..#
          ##.#..#.#.
          .###.####.
          ..###.####
          .##....##.
          .#...####.
          #.##.####.
          ####..#...
          .....##...

          Tile 1427:
          ###.##.#..
          .#..#.##..
          .#.##.#..#
          #.#.#.##.#
          ....#...##
          ...##..##.
          ...#.#####
          .#.####.#.
          ..#..###.#
          ..##.#..#.

          Tile 1489:
          ##.#.#....
          ..##...#..
          .##..##...
          ..#...#...
          #####...#.
          #..#.#.#.#
          ...#.#.#..
          ##.#...##.
          ..##.##.##
          ###.##.#..

          Tile 2473:
          #....####.
          #..#.##...
          #.##..#...
          ######.#.#
          .#...#.#.#
          .#########
          .###.#..#.
          ########.#
          ##...##.#.
          ..###.#.#.

          Tile 2971:
          ..#.#....#
          #...###...
          #.#.###...
          ##.##..#..
          .#####..##
          .#..####.#
          #..#.#..#.
          ..####.###
          ..#.#.###.
          ...#.#.#.#

          Tile 2729:
          ...#.#.#.#
          ####.#....
          ..#.#.....
          ....#..#.#
          .##..##.#.
          .#.####...
          ####.#.#..
          ##.####...
          ##..#.##..
          #.##...##.

          Tile 3079:
          #.#.#####.
          .#..######
          ..#.......
          ######....
          ####.#..#.
          .#...#.##.
          #.#####.##
          ..#.###...
          ..#.......
          ..#.###...
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 20
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D20.new(test: false)
  today.run
end
