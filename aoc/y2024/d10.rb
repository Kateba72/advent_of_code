require_relative '../solution'

# https://adventofcode.com/2024/day/10
module AoC
  module Y2024
    class D10 < Solution

      def part1
        graph, start_coords = parse_input

        start_coords.sum do |start|
          count_ends(graph, start).size
        end
      end

      memoize def count_ends(graph, start)
        start_node = graph.get_node(start)
        ends = Set.new
        start_node.reachable_nodes.each do |other_node|
          if other_node.data[:height] == 9
            ends << other_node
          else
            ends |= count_ends(graph, other_node)
          end
        end

        ends
      end

      def part2
        graph, start_coords = parse_input

        start_coords.sum do |start|
          count_paths(graph, start)
        end
      end

      memoize def count_paths(graph, start)
        start_node = graph.get_node(start)
        start_node.reachable_nodes.sum do |other_node|
          if other_node.data[:height] == 9
            1
          else
            count_paths(graph, other_node)
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        grid = Grid2d.from_string(get_input) { |c| c == '.' ? nil : c.to_i }

        nodes = []
        start_coords = []
        edges = []
        grid.with_coords.each do |height, coord|
          nodes << DirectedNode.new(coord, { height: })
          start_coords << coord if height == 0

          Grid2d::NEIGHBORS.each do |direction|
            neighbor = grid.at(coord + direction)
            next unless height && neighbor == height + 1

            edges << DirectedEdge.new([coord, coord + direction])
          end
        end
        [DirectedGraph.new(nodes:, edges:), start_coords]
      end

      def get_test_input(_number)
        <<~TEST
          89010123
          78121874
          87430965
          96549874
          45678903
          32019012
          01329801
          10456732
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 10
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D10.new(test: test)
  today.run
end
