require_relative '../base_class'
require_relative '../shared/graph'
require_relative '../shared/grid2d'

module AoC
  module Y2023
    class D17 < BaseClass

      def part1
        input = get_input
        nodes = get_nodes
        edges = get_edges(1..3)

        start = Vector[0, 0]
        target = Vector[input.width - 1, input.height - 1]

        edges << DirectedEdge.new([[start, true], [start, false]], { distance: 0 })
        edges << DirectedEdge.new([[target, true], [target, false]], { distance: 0 })

        graph = DirectedGraph.new(nodes:, edges:)
        score, _paths = graph.shortest_path([start, true], [target, false], :distance, -> (x) { x.data[:left] } )

        score
      end

      def part2
        input = get_input
        nodes = get_nodes

        edges = get_edges(4..10)

        start = Vector[0, 0]
        target = Vector[input.width - 1, input.height - 1]

        edges << DirectedEdge.new([[start, true], [start, false]], { distance: 0 })
        edges << DirectedEdge.new([[target, true], [target, false]], { distance: 0 })

        graph = DirectedGraph.new(nodes:, edges:)
        score, _paths = graph.shortest_path([start, true], [target, false], :distance, -> (x) { x.data[:left] } )

        score
      end

      def get_nodes
        input = get_input
        total_distance = input.width + input.height - 2
        input.with_coords.map do |cell, vector|
          [
            DirectedNode.new([vector, true], { left: total_distance - vector[0] - vector[1] }),
            DirectedNode.new([vector, false], { left: total_distance - vector[0] - vector[1] })
          ]
        end.flatten
      end

      def get_edges(steps)
        input = get_input
        input.with_coords.map do |cell, cell_v|
          horizontal = steps.map do |step|
            other = cell_v + Vector[step, 0]
            next unless input.in_bounds? other

            distance = input.row(cell_v[1])[cell_v[0] + 1...other[0]].sum
            [
              DirectedEdge.new([[cell_v, true], [other, false]], { distance: distance + input.at(other) }),
              DirectedEdge.new([[other, true], [cell_v, false]], { distance: distance + cell }),
            ]
          end
          vertical = steps.map do |step|
            other = cell_v + Vector[0, step]
            next unless input.in_bounds? other

            distance = input.column(cell_v[0])[cell_v[1] + 1...other[1]].sum
            [
              DirectedEdge.new([[cell_v, false], [other, true]], { distance: distance + input.at(other) }),
              DirectedEdge.new([[other, false], [cell_v, true]], { distance: distance + cell }),
            ]
          end
          [horizontal, vertical]
        end.flatten.compact
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        arr = super.split("\n").map do |line|
          line.chars.map(&:to_i)
        end
        Grid2d.new(arr)
      end

      def get_test_input(number)
        <<~TEST
          2413432311323
          3215453535623
          3255245654254
          3446585845452
          4546657867536
          1438598798454
          4457876987766
          3637877979653
          4654967986887
          4564679986453
          1224686865563
          2546548887735
          4322674655533
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 17
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D17.new(test: false)
  today.run
end
