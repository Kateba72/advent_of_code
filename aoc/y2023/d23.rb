# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D23 < Solution

      def part1
        parse_input

        nodes = @grid.with_coords.filter_map do |elem, coords|
          DirectedNode.new(coords, { content: elem }) if elem != '#'
        end
        edges = []
        nodes.each do |first_node|
          case first_node.data[:content]
          when '.'
            Grid2d::NEIGHBORS.each do |dir|
              edges << DirectedEdge.new([first_node, first_node.label + dir]) if @grid.at(first_node.label + dir).in? %w[. > v < ^]
            end
          when '<'
            edges << DirectedEdge.new([first_node, first_node.label + Vector[-1, 0]])
          when 'v'
            edges << DirectedEdge.new([first_node, first_node.label + Vector[0, 1]])
          when '>'
            edges << DirectedEdge.new([first_node, first_node.label + Vector[1, 0]])
          when '^'
            edges << DirectedEdge.new([first_node, first_node.label + Vector[0, -1]])
          end
        end

        complex_graph = DirectedGraph.new(nodes:, edges:)
        start = Vector[1, 0]
        graph = complex_graph.simplify([start]) do |complex_edges|
          { distance: complex_edges.size }
        end
        start = graph.get_node(start)
        traverse(graph, start, [])
      end

      def traverse(graph, node, visited, untilnow = 0)
        return 0 if node.label[1] == @grid.height - 1

        visited << node
        max = -100000
        node.outgoing_edges.each do |edge|
          next if visited.include? edge.nodes[1]

          distance = traverse(graph, edge.nodes[1], visited, untilnow + edge.data[:distance]) + edge.data[:distance]
          max = distance if distance > max
        end
        visited.pop
        max
      end

      def part2
        parse_input

        nodes = @grid.with_coords.filter_map do |elem, coords|
          DirectedNode.new(coords, { content: elem }) if elem != '#'
        end
        edges = []
        nodes.each do |first_node|
          Grid2d::NEIGHBORS.each do |dir|
            edges << DirectedEdge.new([first_node, first_node.label + dir]) if @grid.at(first_node.label + dir).in? %w[. > v < ^]
          end
        end

        complex_graph = DirectedGraph.new(nodes:, edges:)
        start = Vector[1, 0]
        graph = complex_graph.simplify([start]) do |complex_edges|
          { distance: complex_edges.size }
        end
        start = graph.get_node(start)
        traverse(graph, start, [])
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        @grid = Grid2d.from_string(get_input)
      end

      def get_test_input(_number)
        <<~TEST
          #.#####################
          #.......#########...###
          #######.#########.#.###
          ###.....#.>.>.###.#.###
          ###v#####.#v#.###.#.###
          ###.>...#.#.#.....#...#
          ###v###.#.#.#########.#
          ###...#.#.#.......#...#
          #####.#.#.#######.#.###
          #.....#.#.#.......#...#
          #.#####.#.#.#########v#
          #.#...#...#...###...>.#
          #.#.#v#######v###.###v#
          #...#.>.#...>.>.#.###.#
          #####v#.#.###v#.#.###.#
          #.....#...#...#.#.#...#
          #.#########.###.#.#.###
          #...###...#...#...#.###
          ###.###.#.###v#####v###
          #...#...#.#.>.>.#.>.###
          #.###.###.#.###.#.#v###
          #.....###...###...#...#
          #####################.#
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 23
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D23.new(test: false)
  today.run
end
