require_relative('./base')
require_relative('../priority_queue')

class DirectedGraph < Graph
  def to_directed_graph
    self
  end

  def single_source_shortest_path(start_node, distance_label)
    start_node = get_node(start_node)

    next_nodes = PriorityQueue.new # [-cost until now, cost until now, node]
    next_nodes << [0, 0, start_node]
    shortest_paths = { start_node => 0 }
    confirmed_nodes = Set.new

    nodes_left = self.nodes.size

    while nodes_left > 0 do
      _, score_until_now, node = next_nodes.pop

      break if _.nil? # We exhausted all paths, but there is no path to the remaining nodes

      next if confirmed_nodes.include? node # if node was already visited, it was with lower costs

      confirmed_nodes << node
      nodes_left -= 1

      node.outgoing_edges.each do |edge|
        score_until_next = score_until_now + edge.data[distance_label]
        target_node = edge.nodes[1]
        unless shortest_paths[target_node]&.<= score_until_next
          next_nodes << [-score_until_next, score_until_next, target_node]
          shortest_paths[target_node] = score_until_next
        end
      end
    end

    shortest_paths
  end

  def shortest_path(start_node, target_node, distance_label, score_until_end_function = -> (_node) { 0 })
    start_node = get_node(start_node)
    target_node = get_node(target_node)

    next_nodes = PriorityQueue.new # [-cost until now, cost until now, node]
    next_nodes << [0, 0, start_node]
    shortest_paths = { start_node => 0 }

    loop do
      _, score_until_now, node = next_nodes.pop

      if node == target_node
        return score_until_now, shortest_paths
      end

      next if shortest_paths[node]&.< score_until_now # if node was already visited with lower costs

      node.outgoing_edges.each do |edge|
        score_until_next = score_until_now + edge.data[distance_label]
        edge_node = edge.nodes[1]
        score_min_until_end = score_until_next + score_until_end_function.call(edge_node)
        unless shortest_paths[edge_node]&.<= score_until_next
          next_nodes << [-score_min_until_end, score_until_next, edge_node]
          shortest_paths[edge_node] = score_until_next
        end
      end
    end

  end

  def simplify(start_nodes, &block)
    q = Queue.new

    kept_nodes = start_nodes.map do |node|
      node = get_node(node)
      q << node
      node
    end.to_set

    new_edges = []

    until q.empty?
      node = q.pop
      node.outgoing_edges.each do |first_edge|
        traversed_edges = [first_edge]
        visited_nodes = [node, first_edge.nodes[1]]
        next_node = first_edge.nodes[1]
        until (reachable_unvisited = next_node.outgoing_edges.filter { |edge| visited_nodes.exclude? edge.nodes[1] }).size != 1
          next_node = reachable_unvisited.first.nodes[1]
          visited_nodes << next_node
          traversed_edges << reachable_unvisited.first
        end
        unless kept_nodes.include? next_node
          kept_nodes << next_node
          q << next_node
        end
        data = block.call(traversed_edges)
        new_edges << DirectedEdge.new([node.label, next_node.label], data)
      end
    end

    new_nodes = kept_nodes.map do |node|
      DirectedNode.new(node.label, node.data.dup)
    end

    DirectedGraph.new(nodes: new_nodes, edges: new_edges)
  end
end

class DirectedNode < Node
  attr_reader :outgoing_edges, :incoming_edges, :reachable_nodes, :reachable_from_nodes

  def initialize(...)
    @outgoing_edges = []
    @reachable_nodes = []
    @incoming_edges = []
    @reachable_from_nodes = []
    super
  end
end

class DirectedEdge < Edge
  def assign_graph(graph)
    return unless graph

    super

    source, sink = @nodes
    source.outgoing_edges << self
    source.reachable_nodes << sink
    sink.incoming_edges << self
    sink.reachable_from_nodes << source
  end
end
