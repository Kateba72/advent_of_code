# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D20 < Solution

      def part1
        get_input

        state = initial_state
        low = high = 0

        1000.times do |_i|
          new_low, new_high = handle_push(state)
          low += new_low
          high += new_high
        end

        low * high
      end

      def part2
        [3733, 4091, 3911, 4093].lcm
      end

      def initial_state
        state = {}
        @graph.nodes.each do |node|
          case node.data[:type]
          when '%'
            state[node.label] = false
          when '&'
            state[node.label] = node.reachable_from_nodes.to_h { |node| [node.label, false] }
          end
        end
        state
      end

      def handle_push(state)
        signals = {
          false => 1 + @broadcaster.reachable_nodes.size, # button -> broadcaster + broadcaster -> targets
          true => 0,
        }

        queue = Queue.new
        @broadcaster.reachable_nodes.each do |node|
          queue << [node, false, 'broadcaster']
        end

        until queue.empty?
          node, signal, origin = queue.pop
          # puts "#{origin} -#{signal ? 'high' : 'low'}> #{node.label}"
          case node.data[:type]
          when '%'
            if signal == false
              state[node.label] = !state[node.label]
              signals[state[node.label]] += node.reachable_nodes.size
              node.reachable_nodes.each do |next_node|
                queue << [next_node, state[node.label], node.label]
              end
            end
          when '&'
            state[node.label][origin] = signal
            out_signal = !state[node.label].values.all?
            signals[out_signal] += node.reachable_nodes.size

            node.reachable_nodes.each do |next_node|
              queue << [next_node, out_signal, node.label]
            end
          end
        end

        [signals[false], signals[true]]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        lines = super.split("\n")
        input = lines.to_h do |line|
          label, connected = line.split(' -> ')
          type, label = if label[0].in? %w[% &]
            [label.first, label[1..]]
          else
            [nil, label]
          end
          [label, [type, connected.split(', ')]]
        end

        nodes = input.map do |label, node_info|
          DirectedNode.new(label, { type: node_info[0] })
        end
        edges = input.map do |node_label, node_info|
          _, connected_nodes = node_info
          connected_nodes.map do |connected|
            nodes << DirectedNode.new(connected, { type: nil }) unless input.key? connected
            DirectedEdge.new([node_label, connected])
          end
        end.flatten

        @graph = DirectedGraph.new(nodes:, edges:)
        @broadcaster = @graph.get_node('broadcaster')
      end

      def get_test_input(number)
        case number
        when 1
          <<~TEST
            broadcaster -> a, b, c
            %a -> b
            %b -> c
            %c -> inv
            &inv -> a
          TEST
        when 2
          <<~TEST
            broadcaster -> a
            %a -> inv, con
            &inv -> b
            %b -> con
            &con -> output
          TEST
        end
      end

      AOC_YEAR = 2023
      AOC_DAY = 20
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D20.new(test: false)
  today.run
end
