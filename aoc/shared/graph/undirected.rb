require_relative('base')
require_relative('directed')

class UndirectedGraph < Graph
  def to_directed_graph
    directed_nodes = nodes.to_h do |node|
      [node.label, DirectedNode.new(node.label, node.data)]
    end
    DirectedGraph.new(
      nodes: directed_nodes.values,
      edges: edges.map do |edge|
        [
          DirectedEdge.new([directed_nodes[edge.nodes.first.label], directed_nodes[edge.nodes.last.label]], edge.data),
          DirectedEdge.new([directed_nodes[edge.nodes.last.label], directed_nodes[edge.nodes.first.label]], edge.data),
        ]
      end.flatten,
    )
  end
end

class UndirectedNode < Node
  attr_reader :edges, :connected_nodes

  def initialize(...)
    @edges = []
    @connected_nodes = []
    super
  end
end

class UndirectedEdge < Edge
  def assign_graph(graph)
    return unless graph

    super

    source, sink = @nodes
    source.edges << self
    source.connected_nodes << sink
    sink.edges << self
    sink.connected_nodes << source
  end
end
