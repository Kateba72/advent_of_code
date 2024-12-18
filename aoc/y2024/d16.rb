require_relative '../solution'

# https://adventofcode.com/2024/day/16
module AoC
  module Y2024
    class D16 < Solution

      def part1
        graph, start = build_graph
        end_tile = graph.get_node('end')

        start_sssp = sssp(graph, start)
        start_sssp[end_tile]
      end

      memoize def sssp(graph, start)
        graph.single_source_shortest_path(start, :score)
      end

      memoize def build_graph
        input = parse_input

        start_tile = end_tile = nil
        existing_pairs = Set.new
        nodes = input.with_coords.filter_map do |elem, coords|
          next if elem == '#'

          start_tile = coords if elem == 'S'
          end_tile = coords if elem == 'E'

          Grid2d::NEIGHBORS.filter_map do |direction|
            next if input.at(coords + direction) == '#' && input.at(coords - direction) == '#' && elem == '.'

            existing_pairs << [coords, direction]
            DirectedNode.new([coords, direction])
          end
        end.flatten

        edges = []
        nodes.each do |node|
          coords, direction = node.label
          possible_neighbors = [
            [[coords + direction, direction], 1],
            [[coords, Vector[direction[1], -direction[0]]], 1000],
            [[coords, Vector[-direction[1], direction[0]]], 1000],
          ]
          possible_neighbors.each do |label, distance|
            next unless existing_pairs.include? label

            edges << DirectedEdge.new([node, label], { score: distance })
          end
        end

        nodes << DirectedNode.new('end')
        Grid2d::NEIGHBORS.each do |direction|
          edges << DirectedEdge.new([[end_tile, direction], 'end'], { score: 0 })
        end

        complex_graph = DirectedGraph.new(nodes:, edges:)
        start = [start_tile, Grid2d::RIGHT]
        # graph = complex_graph.simplify([start]) do |complex_edges|
        #  { score: complex_edges.sum { _1.data[:score] } }
        # end

        [complex_graph, start]
      end

      def part2
        graph, start = build_graph
        start_sssp = sssp(graph, start)

        reversed_graph = graph.reverse
        end_sssp = sssp(reversed_graph, 'end').transform_keys(&:label)

        shortest_path = start_sssp[graph.get_node('end')]

        start_sssp.filter_map do |node, start_score|
          end_score = end_sssp[node.label]
          next unless end_score # This happens for dead ends, because a backtracking alogithm doesn't visit those
          next unless start_score + end_score == shortest_path

          node.label.first
        end.uniq.size - 1
        # minus one for the 'end' node
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
          ###############
          #.......#....E#
          #.#.###.#.###.#
          #.....#.#...#.#
          #.###.#####.#.#
          #.#.#.......#.#
          #.#.#####.###.#
          #...........#.#
          ###.#.#####.#.#
          #...#.....#.#.#
          #.#.#.###.#.#.#
          #.....#...#.#.#
          #.###.#.#.#.#.#
          #S..#.....#...#
          ###############
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 16
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D16.new(test: test)
  today.run
end
