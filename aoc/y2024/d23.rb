require_relative '../solution'

# https://adventofcode.com/2024/day/23
module AoC
  module Y2024
    class D23 < Solution

      def part1
        graph = build_graph

        found_cycles = Set.new
        graph.nodes.each do |node|
          next unless node.label.start_with? 't'

          node.connected_nodes.each do |other_node|
            node.data[:connected].intersection(other_node.data[:connected]).each do |third_node|
              found_cycles << [node, other_node, third_node].map(&:label).sort
            end
          end
        end

        found_cycles.size
      end

      def part2
        graph = build_graph

        max = []
        graph.nodes.each do |node|
          this_max = enlarge_clique([node], node.data[:connected], max.size)
          max = this_max if this_max.size >= max.size
        end

        max.map(&:label).sort.join(',')
      end

      memoize def build_graph
        nodes = {}
        edges = []

        parse_input.each do |connection|
          connection.each do |label|
            nodes[label] = UndirectedNode.new(label) unless nodes.key? label
          end

          edges << UndirectedEdge.new(connection)
        end

        graph = UndirectedGraph.new(nodes: nodes.values, edges:)

        graph.nodes.each do |node|
          node.data[:connected] = node.connected_nodes.to_set
        end

        graph
      end

      def enlarge_clique(clique, possible_nodes, max_size)
        return clique if clique.size + possible_nodes.size <= max_size

        max = clique
        possible_nodes = possible_nodes.to_a
        while possible_nodes.present?
          next_node = possible_nodes.pop

          next_possible_nodes = next_node.data[:connected].intersection(possible_nodes)
          clique << next_node
          next_max = enlarge_clique(clique, next_possible_nodes, max_size)
          if next_max.size >= max_size
            max = next_max.dup
            max_size = next_max.size
          end
          clique.pop
        end

        max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map { _1.split('-') }
      end

      def get_test_input(_number)
        <<~TEST
          kh-tc
          qp-kh
          de-cg
          ka-co
          yn-aq
          qp-ub
          cg-tb
          vc-aq
          tb-ka
          wh-tc
          yn-cg
          kh-ub
          ta-co
          de-co
          tc-td
          tb-wq
          wh-td
          ta-ka
          td-qp
          aq-cg
          wq-ub
          ub-vc
          de-ta
          wq-aq
          wq-vc
          wh-yn
          ka-de
          kh-ta
          co-tc
          wh-qp
          tb-vc
          td-yn
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 23
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D23.new(test: test)
  today.run
end
