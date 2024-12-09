require_relative '../solution'

# https://adventofcode.com/2021/day/12
module AoC
  module Y2021
    class D12 < Solution

      def part1
        graph, lower_caves = parse_input

        count_paths(graph, 'start', [true] + [false] * lower_caves)
      end

      def part2
        graph, lower_caves = parse_input

        count_paths(graph, 'start', [false] * (lower_caves + 1))
      end

      memoize def count_paths(graph, node, visited)
        graph.get_node(node).connected_nodes.sum do |other_node|
          if other_node.label == 'start'
            0
          elsif other_node.label == 'end'
            1
          elsif (ord = other_node.data[:ord])
            if !visited[ord]
              v = visited.dup
              v[ord] = true
              count_paths(graph, other_node, v)
            elsif !visited[0]
              v = visited.dup
              v[0] = true
              count_paths(graph, other_node, v)
            else
              0
            end
          else
            count_paths(graph, other_node, visited)
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        paths = get_input.split("\n")
        nodes = {}
        edges = []
        lower_caves = 0
        paths.each do |path|
          path_nodes = path.split('-').map do |node|
            node_data = {}
            node_data[:ord] = (lower_caves += 1) if node.match(/[a-z]+/) && %w[start end].exclude?(node)
            nodes[node] ||= UndirectedNode.new(node, node_data)
          end

          edges << UndirectedEdge.new(path_nodes)
        end

        [UndirectedGraph.new(nodes: nodes.values, edges:), lower_caves]
      end

      def get_test_input(_number)
        <<~TEST
          start-A
          start-b
          A-c
          A-b
          b-d
          A-end
          b-end
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2021::D12.new(test: test)
  today.run
end
