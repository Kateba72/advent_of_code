require_relative '../solution'

# https://adventofcode.com/2024/day/18
module AoC
  module Y2024
    class D18 < Solution

      def part1
        graph = build_graph
        target = Vector[@max_coord, @max_coord]
        out, _, sp_data = graph.shortest_path(Vector[0, 0], target, :length, ->(node) { node.data[:distance] })
        @sp_data = sp_data

        out
      end

      def part2
        graph = build_graph
        # The graph is known to continue a path for now
        on_path = parse_path(graph, @sp_data)

        input = parse_input

        input[@first_part_limit..].each do |removed|
          node = graph.get_node(removed)
          node.outgoing_edges.each do |edge|
            edge.data[:length] = 1_000_000
          end

          next if on_path.exclude? removed

          len, _, new_path = graph.shortest_path(Vector[0, 0], Vector[@max_coord, @max_coord], :length, ->(n) { n.data[:distance] })
          return removed if len > 1_000_000

          on_path = parse_path(graph, new_path)
        end
      end

      memoize def build_graph
        input = parse_input
        unpassable = input[...@first_part_limit].to_set

        nodes = []
        edges = []

        (0..@max_coord).each do |x|
          (0..@max_coord).each do |y|
            v = Vector[x, y]
            next if unpassable.include? v

            nodes << DirectedNode.new(v, { distance: 2 * @max_coord - x - y })
            Grid2d::NEIGHBORS.each do |dir|
              neighbor = v + dir
              next if neighbor[0] < 0 || neighbor[1] < 0 || neighbor[0] > @max_coord || neighbor[1] > @max_coord

              edges << DirectedEdge.new([v, neighbor], { length: 1 }) unless unpassable.include? neighbor
            end
          end
        end

        DirectedGraph.new(nodes:, edges:)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
        @max_coord = testing? ? 6 : 70
        @first_part_limit = testing? ? 12 : 1024
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          Vector[*line.integers]
        end
      end

      def parse_path(graph, visited_from)
        path = Set.new
        node = graph.get_node(Vector[@max_coord, @max_coord])
        start = graph.get_node(Vector[0, 0])

        while node != start
          path << node.label
          node = visited_from[node]
        end

        path << start.label
        path
      end

      def get_test_input(_number)
        <<~TEST
          5,4
          4,2
          4,5
          3,0
          2,1
          6,3
          2,4
          1,5
          0,6
          3,3
          2,6
          5,1
          1,2
          5,5
          2,5
          6,5
          1,4
          0,4
          6,4
          1,1
          6,1
          1,0
          0,5
          1,6
          2,0
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 18
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D18.new(test: test)
  today.run
end
