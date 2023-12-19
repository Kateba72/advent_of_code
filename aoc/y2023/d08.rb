# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D08 < Solution

      def part1
        instructions, directions = get_input
        node = 'AAA'
        (0..).each do |i|
          break i if node == 'ZZZ'
          if instructions[i % instructions.size] == 'L'
            node = directions[node][0]
          else
            node = directions[node][1]
          end
        end

      end

      def part2
        instructions, directions = get_input
        nodes = directions.keys.filter { |k| k.end_with? 'A' }
        loop_sizes = nodes.map do |start_node|
          node = start_node
          steps = {}
          (0..).each do |i|
            instruction = i % instructions.size
            if (old_step = steps[[instruction, node]])
              loop_size = i - old_step
              f_steps = steps.filter_map do |key, step|
                if key[1].ends_with? 'Z'
                  [key[0], step]
                end
              end
              raise "f_steps is #{f_steps.inspect}, loop_size is #{loop_size}" unless f_steps == [[0, loop_size]]
              # This was true for my input:
              # The only time the loop visits a node ending with Z is at step loop_size, meaning that it visits the node
              # every time the step size is a multiple of loop_size
              break loop_size
            end
            steps[[instruction, node]] = i
            node = if instructions[i % instructions.size] == 'L'
              directions[node][0]
            else
              directions[node][1]
            end
          end
        end

        loop_sizes.reduce(1, :lcm)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        instructions, directions = super.split("\n\n")
        directions = directions.split("\n").to_h do |line|
          m = line.match /^(\w+) = \((\w+), (\w+)\)$/
          [m.captures[0], m.captures[1..]]
        end
        [instructions, directions]
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 8
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D08.new(test: false)
  today.run
end
