# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D21 < Solution

      def part1
        get_input

        steps = testing? ? 6 : 64

        distances = @graph.single_source_shortest_path(@start, :distance).values
        distances.count { |v| (v - steps) % 2 == 0 && v <= steps }
      end

      def part2
        steps = testing? ? 17 : 26501365
        half_size = (@grid.width - 1) / 2

        corner_distances = @grid.corners.map do |corner|
          @graph.single_source_shortest_path(corner, :distance).values
        end

        # <half_size> steps to the edge of the starting block. Then <2*half_size+1> steps per block
        block_steps = (steps - half_size) / (2 * half_size + 1)

        # Notes/Assumptions:
        # The direct paths from the start point to the edges are free of rocks
        # The edges are free of rocks
        # The starting point is exactly in the middle of the input

        # Then the blocks look roughly like this (example for 2 block steps)

        #          ╎   ╎
        #         ╌╆━━━╅╌
        #          ┃/ \┃
        #          ┃ O ┃
        #      ╎  /┃   ┃\  ╎
        #     ╌╆━━━╋━━━╋━━━╅╌
        #      ┃/  ┃   ┃  \┃
        #      ┃ O ┃ E ┃ O ┃
        #  ╎  /┃   ┃   ┃   ┃\  ╎
        # ╌╆━━━╋━━━╋━━━╋━━━╋━━━╅╌
        #  ┃/  ┃   ┃   ┃   ┃  \┃
        #  ┃ O ┃ E ┃ S ┃ E ┃ O ┃
        #  ┃\  ┃   ┃ O ┃   ┃  /┃
        # ╌╄━━━╋━━━╋━━━╋━━━╋━━━╃╌
        #  ╎  \┃   ┃   ┃   ┃/  ╎
        #      ┃ O ┃ E ┃ O ┃
        #      ┃\  ┃   ┃  /┃
        #     ╌╄━━━╋━━━╋━━━╃╌
        #      ╎  \┃   ┃/  ╎
        #          ┃ O ┃
        #          ┃\ /┃
        #         ╌╄━━━╃╌
        #          ╎   ╎

        # We call a block "mostly reachable" if we can reach the midpoints of all edges. We may miss a corner, though
        # (the heavy boxes in the graphic above)
        mostly_reachable_blocks_even = 4 * ((block_steps / 2) ** 2)
        mostly_reachable_blocks_odd = 4 * (block_steps / 2) * (block_steps / 2 + 1) + 1
        reachable_gardens_odd = mostly_reachable_blocks_odd * corner_distances[0].count { |v| v % 2 == 1 }
        reachable_gardens_even = mostly_reachable_blocks_even * corner_distances[0].count { |v| v % 2 == 0 }


        # for each corner, we miss that corner (n+1) times
        # blocks without corners have the same parity as the last block in a straight line
        missed_corner_parity = (block_steps + 1) % 2
        missed_corner_gardens = (block_steps + 1) * corner_distances.sum do |distances|
          distances.count { |v| v % 2 == missed_corner_parity && v > half_size * 3 }
        end

        # We get each additional corner n times
        # The parity is different from the missed corners
        additional_corner_parity = block_steps % 2
        additional_corner_gardens = block_steps * corner_distances.sum do |distances|
          distances.count { |v| v % 2 == additional_corner_parity && v < half_size }
        end

        reachable_gardens_odd + reachable_gardens_even - missed_corner_gardens + additional_corner_gardens
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def assert_sssp(sssp, corners, max)
        raise unless max == sssp.values.max
        sssp.each do |node, distance|
          raise [node, distance, corners].inspect if distance == max && !corners.include?(node.label)
        end
      end

      def get_input
        @grid = Grid2d.new(super.split("\n").map(&:chars))
        start_y = @grid.grid.index do |row|
          row.include? 'S'
        end
        start_x = @grid.row(start_y).index('S')
        @start = Vector[start_x, start_y]
        @grid.set_at(@start, '.')

        build_graph
      end

      def build_graph
        nodes = []
        edges = []
        @grid.with_coords.each do |elem, vector|
          next if elem == '#'
          nodes << UndirectedNode.new(vector)
          edges << UndirectedEdge.new([vector, vector + Vector[1, 0]], { distance: 1 }) if @grid.at(vector + Vector[1, 0]) == '.'
          edges << UndirectedEdge.new([vector, vector + Vector[0, 1]], { distance: 1 }) if @grid.at(vector + Vector[0, 1]) == '.'
        end

        @graph = UndirectedGraph.new(nodes:, edges:).to_directed_graph
      end

      def get_test_input(number)
        case number
        when 1
        <<~TEST
          ...........
          .....###.#.
          .###.##..#.
          ..#.#...#..
          ....#.#....
          .##..S####.
          .##..#...#.
          .......##..
          .##.#.####.
          .##..##.##.
          ...........
        TEST
        when 2
          <<~TEST
            .......
            .......
            .......
            ...S...
            .......
            .......
            .......
          TEST
        end
      end

      AOC_YEAR = 2023
      AOC_DAY = 21
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D21.new(test: false)
  today.run
end
