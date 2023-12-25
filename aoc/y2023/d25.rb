require_relative '../solution'

# Global Minimum Cut

module AoC
  module Y2023
    class D25 < Solution

      NodeData = Struct.new(:height, :excess, :in_cut, :edge_search_offset)
      EdgeData = Struct.new(:flow)

      def part1
        parse_input
        @working_nodes = @graph.nodes.to_set
        large_value = 2 * @graph.edges.size

        @layers = Array.new(@graph.nodes.size) { Set.new }
        @layers[0] = @graph.nodes.to_set
        @lowest_layer = 0

        source_set = Set.new
        @sink = @graph.nodes.first

        @active_nodes = Set.new

        (0..).each do |i|
          source_set << @sink

          @working_nodes.each do |n|
            n.data.in_cut = false
          end
          @sink.data.excess = large_value
          @sink.edges.each { |e| push(e, @sink) }
          @sink.data.in_cut = true
          @layers[@sink.data.height].delete(@sink)
          @lowest_layer += 1 if @layers[@lowest_layer].empty?
          @sink.data.height = large_value
          @working_nodes.delete(@sink)

          @sink = @layers[@lowest_layer].first

          @lowest_height_in_cut = @graph.nodes.size

          while @active_nodes.present?
            node = @active_nodes.first
            while node.data.edge_search_offset < node.edges.size
              edge = node.edges[node.data.edge_search_offset]
              if edge_eligible?(edge, node)
                push(edge, node)

                if node.data.excess == 0
                  @active_nodes.delete(node)
                  break
                end
              end

              node.data.edge_search_offset += 1
            end
            next if node.data.excess == 0

            if has_falling_residual_edges?(node)
              fix_safe_nodes(node)
              next if node.data.in_cut
            end

            relabel(node)
          end

          cut_size = @sink.data.excess
          if cut_size <= 3
            cut_size = source_set.size + @working_nodes.count { |n| n.data.in_cut }
            return cut_size * (@graph.nodes.size - cut_size)
          end
        end
      end

      def edge_eligible?(edge, start_node)
        if start_node == edge.nodes.first
          end_node = edge.nodes.second
          edge.data.flow < 1 && start_node.data.height == end_node.data.height + 1 && !end_node.data.in_cut
        else
          end_node = edge.nodes.first
          edge.data.flow > -1 && start_node.data.height == end_node.data.height + 1 && !end_node.data.in_cut
        end
      end

      def node_active?(node)
       !node.data.in_cut && node != @sink && node.data.excess > 0
      end

      def has_falling_residual_edges?(node)
        node.edges.any? do |edge|
          if edge.nodes.first == node
            end_node = edge.nodes.second
            edge.data.flow > 0 && node.data.height > end_node.data.height
          else
            end_node = edge.nodes.first
            edge.data.flow < 0 && node.data.height > end_node.data.height
          end
        end
      end

      def node_safe(node)
        node.data.in_cut && node.data.height == @lowest_height_in_cut
      end

      def push(edge, start_node)
        # Precondition: start_node is active, edge is eligible
        push_amount = if start_node == edge.nodes.first
          end_node = edge.nodes.second
          residual_capacity = 1 - edge.data.flow
          [residual_capacity, start_node.data.excess].min
        else
          end_node = edge.nodes.first
          residual_capacity = 1 + edge.data.flow
          - [residual_capacity, start_node.data.excess].min
        end
        edge.nodes.first.data.excess -= push_amount
        edge.nodes.second.data.excess += push_amount
        edge.data.flow += push_amount

        if node_active?(end_node)
          @active_nodes << end_node
        end
      end

      def relabel(node)
        # Precondition: node is active, has no residual falling edge to V \ X
        #  or node is safe
        # Returns whether a transfer to the cut occurred (true) or a node's height was increased (false)
        if @layers[node.data.height].size > 1 || node.data.height == @lowest_layer
          @layers[node.data.height].delete(node)
          @lowest_layer += 1 if @layers[node.data.height].empty?
          node.data.height += 1
          @layers[node.data.height].add(node)
          node.data.edge_search_offset = 0
          false
        else
          @lowest_height_in_cut = node.data.height
          @working_nodes.each do |n|
            if n.data.height >= @lowest_height_in_cut
              unless n.data.in_cut
                n.data.in_cut = true
                @active_nodes.delete n
              end
            end
          end
          true
        end
      end

      def fix_safe_nodes(unsafe_node)
        # unsafe node is not in the cut, but has residual edges into the cut.
        # Relabel the nodes in the cut until that isn't the case anymore
        while @lowest_height_in_cut < unsafe_node.data.height && !unsafe_node.data.in_cut
          result = nil
          @layers[@lowest_height_in_cut].each do |node|
            next unless node.data.in_cut
            result = relabel(node)
            break if result
          end
          @lowest_height_in_cut += 1 unless result
        end
      end

      private

      def parse_input
        lines = get_input.split("\n")
        node_labels = Set.new
        edges = []
        lines.map do |line|
          node, connected = line.split(": ")
          connected = connected.split
          node_labels << node
          connected.each do |conn|
            node_labels << conn
            edges << UndirectedEdge.new([node, conn])
          end
        end
        nodes = node_labels.map do |label|
          UndirectedNode.new(label, NodeData.new(0, 0, false, 0))
        end

        @graph = Graph.new(nodes: nodes, edges: edges)
        @graph.edges.each do |edge|
          edge.data = EdgeData.new(0)
        end
      end

      def get_test_input(number)
        <<~TEST
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 25
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D25.new(test: false)
  today.run
end
