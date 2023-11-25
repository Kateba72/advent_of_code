require 'active_support'; require 'active_support/core_ext'
require_relative 'shared/graph/directed'
require 'byebug'

graph = DirectedGraph.new(
  nodes: [
    DirectedNode.new(1),
    DirectedNode.new(2),
    DirectedNode.new(3),
  ],
  edges: [
    DirectedEdge.new([2, 1], { distance: 1 }),
    DirectedEdge.new([1, 3], { distance: 3 }),
    DirectedEdge.new([1, 2], { distance: 3 }),
  ]
)

p graph.single_source_shortest_path(2, :distance)
p graph.single_source_shortest_path(1, :distance)
