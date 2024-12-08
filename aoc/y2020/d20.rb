require 'matrix'
require_relative '../solution'

module AoC
  module Y2020
    class D20 < Solution

      #  01234567890123456789
      # "                  # "
      # "#    ##    ##    ###"
      # " #  #  #  #  #  #   "
      MONSTER = [
        Vector[19, 1], # put the two possibly out-of-bounds locations first
        Vector[16, 2],
        Vector[18, 0],
        Vector[0, 1],
        Vector[5, 1],
        Vector[6, 1],
        Vector[11, 1],
        Vector[12, 1],
        Vector[17, 1],
        Vector[18, 1],
        Vector[1, 2],
        Vector[4, 2],
        Vector[7, 2],
        Vector[10, 2],
        Vector[13, 2],
      ].freeze

      def part1
        input = get_input
        edges = parse_edges(input)
        corner_pieces = find_corners(edges)
        corner_pieces.uniq.inject(&:*)
      end

      def part2
        input = get_input
        edges = parse_edges(input)
        top_left_id = find_corners(edges).first # assign any corner as top left
        top_left = input[top_left_id]
        top_left = top_left.flip_vertical

        # rotate the top left corner until its unconnected edges are at the top left
        top = correct_edge(top_left.row(0))
        top_unconnected = edges[top].size < 2
        left = correct_edge(top_left.column(0))
        left_unconnected = edges[left].size < 2
        top_left = if top_unconnected && left_unconnected
          top_left
        elsif top_unconnected
          top_left.rot90_ccw
        elsif left_unconnected
          top_left.rot90_cw
        else
          top_left.rot180
        end

        picture = Grid2d.new(fill_picture(top_left, top_left_id, input, edges))
        puts picture.map(&:join).join("\n") if @grid_test

        monster_tiles = MONSTER.size * begin
          r = monster_count(picture)
          r = monster_count(picture.rot90_cw) if r == 0
          r = monster_count(picture.rot180) if r == 0
          r = monster_count(picture.rot90_ccw) if r == 0
          picture = picture.flip_horizontal if r == 0
          r = monster_count(picture) if r == 0
          r = monster_count(picture.rot90_cw) if r == 0
          r = monster_count(picture.rot180) if r == 0
          r = monster_count(picture.rot90_ccw) if r == 0
          r
        end

        picture.grid.flatten.count('#') - monster_tiles
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @grid_test = false
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n\n").to_h do |tile|
          lines = tile.split("\n")
          tileno = lines[0].ints[0]
          matrix = Grid2d.new(lines[1..].map(&:chars))
          [tileno, matrix]
        end
      end

      memoize def parse_edges(input)
        edges = {}

        input.each do |tileno, tile|
          # top, left, bottom, right
          [tile.row(0), tile.column(0), tile.row(tile.height - 1), tile.column(tile.width - 1)].each_with_index do |edge, index|
            edge = edge.to_a
            if (edge <=> edge.reverse) == -1
              edge = edge.reverse
              index = - index
            end
            edges[edge] ||= []
            edges[edge] << [tileno, index]
          end
        end

        edges
      end

      memoize def find_corners(edges)
        edge_pieces = edges.values.filter_map do |tiles|
          raise 'ambiguous' if tiles.count >= 3

          tiles.count == 2 ? nil : tiles.map(&:first)
        end.compact.flatten

        edge_pieces.filter { |p| edge_pieces.count(p) > 1 }
      end

      def fill_picture(top_left, top_left_id, tiles, edges)
        picture = fill_picture_row(top_left, top_left_id, tiles, edges)

        bottom_id = top_left_id
        bottom_edge = top_left.row(top_left.height - 1)
        c_bottom_edge = correct_edge(bottom_edge)
        next_tile_id, next_rotation = edges[c_bottom_edge].filter do |tile, _orientation|
          tile != bottom_id
        end.first

        while next_tile_id
          next_tile = tiles[next_tile_id]

          next_tile = case next_rotation.abs
          when 0 # top
            next_tile
          when 1 # left
            next_tile.rot90_cw
          when 2 # bottom
            next_tile.rot180
          when 3 # right
            next_tile.rot90_ccw
          end

          next_tile = next_tile.flip_horizontal if next_tile.row(0) != bottom_edge
          raise unless next_tile.row(0) == bottom_edge

          picture_row = fill_picture_row(next_tile, next_tile_id, tiles, edges)
          picture << [] if @grid_test
          picture.append(*picture_row)

          bottom_id = next_tile_id
          bottom_edge = next_tile.row(next_tile.height - 1)
          c_bottom_edge = correct_edge(bottom_edge)
          next_tile_id, next_rotation = edges[c_bottom_edge].filter do |tile, _orientation|
            tile != bottom_id
          end.first
        end

        picture
      end

      def fill_picture_row(left_tile, left_tile_id, tiles, edges)
        picture = left_tile[1...-1].map { _1[1...-1] }

        right_id = left_tile_id
        right_edge = left_tile.column(left_tile.width - 1)
        c_right_edge = correct_edge(right_edge)
        next_tile_id, next_rotation = edges[c_right_edge].filter do |tile, _orientation|
          tile != right_id
        end.first

        while next_tile_id
          next_tile = tiles[next_tile_id]

          next_tile = case next_rotation.abs
          when 0 # top
            next_tile.rot90_ccw
          when 1 # left
            next_tile
          when 2 # bottom
            next_tile.rot90_cw
          when 3 # right
            next_tile.rot180
          end

          next_tile = next_tile.flip_vertical if next_tile.column(0) != right_edge
          raise unless next_tile.column(0) == right_edge

          picture.zip(next_tile[1...-1]).each do |picture_row, tile_row|
            picture_row << ' ' if @grid_test
            picture_row.append(*tile_row[1...-1])
          end

          right_id = next_tile_id
          right_edge = next_tile.column(next_tile.width - 1)
          c_right_edge = correct_edge(right_edge)
          next_tile_id, next_rotation = edges[c_right_edge].filter do |tile, _orientation|
            tile != right_id
          end.first
        end

        picture
      end

      memoize def correct_edge(edge)
        (edge <=> edge.reverse) == -1 ? edge.reverse : edge
      end

      def monster_count(picture)
        picture.with_coords.count do |_item, coord|
          MONSTER.all? do |monster|
            picture.at(coord + monster) == '#'
          end
        end
      end

      def get_test_input(_number)
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
