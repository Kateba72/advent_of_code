require_relative '../solution'

# https://adventofcode.com/2024/day/20
module AoC
  module Y2024
    class D20 < Solution

      def part1
        grid, start_pos, end_pos = parse_input

        graph = build_graph(grid)

        from_start = graph.single_source_shortest_path(start_pos, :distance)
        from_end = graph.single_source_shortest_path(end_pos, :distance)

        normal_costs = from_start[graph.get_node(end_pos)]

        cheat_reachable = [
          Vector[2, 0],
          Vector[1, 1],
          Vector[0, 2],
          Vector[-1, 1],
          Vector[-2, 0],
          Vector[-1, -1],
          Vector[0, -2],
          Vector[1, -1],
        ].freeze

        from_start.sum do |node, costs_until|
          cheat_reachable.count do |cheat_dir|
            cheat_node = graph.get_node(node.label + cheat_dir)

            path_costs = costs_until + from_end[cheat_node] + 2
            normal_costs - path_costs >= 100
          rescue Graph::NoSuchNodeError
            false
          end
        end
      end

      def part2
        grid, start_pos, end_pos = parse_input

        graph = build_graph(grid)

        from_start = graph.single_source_shortest_path(start_pos, :distance)
        from_end = graph.single_source_shortest_path(end_pos, :distance)

        normal_costs = from_start[graph.get_node(end_pos)]

        cheat_reachable = (-20..20).map do |x|
          x_abs = x.abs
          ((-20 + x_abs)..(20 - x_abs)).map do |y|
            [Vector[x, y], x_abs + y.abs]
          end
        end.flatten(1)

        from_start.sum do |node, costs_until|
          cheat_reachable.count do |cheat_dir, cheat_cost|
            cheat_node = graph.get_node(node.label + cheat_dir)

            path_costs = costs_until + from_end[cheat_node] + cheat_cost
            normal_costs - path_costs >= 100
          rescue Graph::NoSuchNodeError
            false
          end
        end
      end

      def build_graph(grid)
        nodes = []
        edges = []
        grid.with_coords.each do |ch, coords|
          next if ch == '#'

          nodes << DirectedNode.new(coords)
          Grid2d::NEIGHBORS.each do |dir|
            other_ch = grid.at(coords + dir)
            next if other_ch == '#'

            edges << DirectedEdge.new([coords, coords + dir], { distance: 1 })
          end
        end
        DirectedGraph.new(nodes:, edges:)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        grid = Grid2d.from_string(get_input)
        start_pos = end_pos = nil
        grid.with_coords.each do |ch, coords|
          if ch == 'S'
            start_pos = coords
            grid.set_at(coords, '.')
          elsif ch == 'E'
            end_pos = coords
            grid.set_at(coords, '.')
          end
        end
        [grid, start_pos, end_pos]
      end

      def get_test_input(_number)
        <<~TEST
          ###############
          #...#...#.....#
          #.#.#.#.#.###.#
          #S#...#.#.#...#
          #######.#.#.###
          #######.#.#...#
          #######.#.###.#
          ###..E#...#...#
          ###.#######.###
          #...###...#...#
          #.#####.#.###.#
          #.#...#.#.#...#
          #.#.#.#.#.#.###
          #...#...#...###
          ###############
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 20
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D20.new(test: test)
  today.run
end
