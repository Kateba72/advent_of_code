# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D22 < Solution

      def part1
        process_bricks

        @on_top_of.count do |lower, on_tops|
          on_tops.all? { |ot| @resting_on[ot].size > 1 }
        end
      end

      def part2
        process_bricks

        @resting_on.keys.sum do |disintegrated|
          on_top = recursive_on_top_of(disintegrated)
          disint_blocks = [disintegrated]
          on_top.to_a.sort.each do |block|
            if @resting_on[block].all? { |ro| disint_blocks.include? ro }
              disint_blocks << block
            end
          end

          disint_blocks.size - 1
        end
      end

      def process_bricks
        return if @on_top_of

        @resting_on = {}
        @on_top_of = {}

        bricks = get_input

        bricks = bricks.sort_by do |brick|
          [brick[0][2], brick[1][2]].min
        end

        heights = {} # [x, y] => highest z
        bricks_by_position = {}

        bricks.each_with_index do |brick, i|
          surface = (brick[0][0]..brick[1][0]).to_a.product((brick[0][1]..brick[1][1]).to_a)
          current_height = [brick[0][2], brick[1][2]].min
          final_height = surface.map { |x, y| heights[[x, y]] || 0 }.max + 1
          fall = Vector[0, 0, final_height - current_height]
          fallen = [brick[0] + fall, brick[1] + fall]

          @resting_on[i] = []
          @on_top_of[i] = []
          surface.each do |x, y|
            heights[[x, y]] = fallen[0][2]
            bricks_by_position[Vector[x, y, fallen[0][2]]] = i

            if (lower_brick = bricks_by_position[Vector[x, y, final_height - 1]])
              unless @resting_on[i].include? lower_brick
                @resting_on[i] << lower_brick
                @on_top_of[lower_brick] << i
              end
            end

          end
          if fallen[0][2] < fallen[1][2]
            heights[[fallen[0][0], fallen[0][1]]] = fallen[1][2]
            bricks_by_position[fallen[1]] = i
          elsif fallen[0][2] > fallen[1][2]
            bricks_by_position[fallen[0]] = i
          end

          fallen
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      memoize def recursive_on_top_of(index)
        direct = @on_top_of[index]
        on_top_of_i = direct.to_set
        direct.each do |on_top|
          on_top_of_i |= recursive_on_top_of(on_top)
        end
        on_top_of_i
      end

      private

      def get_input
        super.split("\n").map do |line|
          ints = line.integers
          [Vector[*ints[..2]], Vector[*ints[3..]]]
        end
      end

      def get_test_input(number)
        <<~TEST
          1,0,1~1,2,1
          0,0,2~2,0,2
          0,2,3~2,2,3
          0,0,4~0,2,4
          2,0,5~2,2,5
          0,1,6~2,1,6
          1,1,8~1,1,9
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 22
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D22.new(test: false)
  today.run
end
