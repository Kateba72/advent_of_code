class Graph
  attr_reader :nodes, :edges, :nodes_by_label

  def initialize(nodes:, edges:)
    @nodes = nodes
    @edges = edges

    @nodes_by_label = {}

    nodes.each do |node|
      node.assign_graph(self)
      @nodes_by_label[node.label] = node
    end

    edges.each do |edge|
      edge.assign_graph(self)
    end
  end

  def get_node(node_or_label)
    return node_or_label if node_or_label.is_a? Node
    node = @nodes_by_label[node_or_label]
    raise "Could not map #{node_or_label} to a label" if node.blank?
    node
  end

  def inspect
    "<#{self.class.name} nodes=(#{self.nodes.size} nodes) edges=(#{self.edges.size} edges)>"
  end
end

class Node
  attr_accessor :data
  attr_reader :graph, :label

  def initialize(label, data = {}, graph = nil)
    @label = label
    @data = data
    assign_graph(graph)
  end

  def assign_graph(graph)
    raise 'This edge is already assigned to another graph' if @graph
    return unless graph

    @graph = graph
  end

  def inspect
    "<#{self.class.name} @label=#{label.inspect}>"
  end
end

class Edge
  attr_accessor :data
  attr_accessor :nodes
  attr_reader :graph

  def initialize(nodes, data = {}, graph = nil)
    @nodes = nodes
    raise "An edge needs exactly two nodes, #{nodes.size} given" unless nodes.size == 2
    @data = data
    assign_graph(graph)
  end

  def assign_graph(graph)
    raise 'This edge is already assigned to another graph' if @graph
    return unless graph

    @graph = graph

    @nodes = @nodes.map do |node|
      graph.get_node(node)
    end
  end

  def inspect
    "<#{self.class.name} @nodes=#{nodes.inspect} @data=#{data.inspect}>"
  end
end
