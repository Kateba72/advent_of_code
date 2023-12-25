require_relative '../solution'

module AoC
  module Y2022
    class D08 < Solution

      def part1
        visibility.sum { |line| line.sum }
      end

      def part2
        input = parse_input

        maximum = 0
        input[1..-1].each_with_index do |line, input_index|
          line[1..-1].each_with_index do |tree, line_index|
            tree_score = score tree, line[(line_index + 2)..]
            tree_score *= score tree, line[..line_index].reverse
            tree_score *= score tree, input[(input_index + 2)..].map { |l| l[line_index + 1] }
            tree_score *= score tree, input[..input_index].map { |l| l[line_index + 1] }.reverse

            maximum = tree_score > maximum ? tree_score : maximum
          end
        end

        maximum
      end

      private

      def visibility
        input = parse_input
        visible_top = [-1] * input[0].size
        visible = input.map do |line|
          visible_line = [0] * input[0].size
          visible_left = -1
          line.each_with_index do |tree, index|
            if tree > visible_left
              visible_line[index] = 1
              visible_left = tree
            end
            if tree > visible_top[index]
              visible_line[index] = 1
              visible_top[index] = tree
            end
          end
          visible_line
        end

        visible_bottom = [-1] * input[0].size
        input.reverse.map.with_index do |line, input_index|
          visible_right = -1
          line.reverse.each_with_index do |tree, line_index|
            if tree > visible_right
              visible[input.size - input_index - 1][line.size - line_index - 1] = 1
              visible_right = tree
            end
            if tree > visible_bottom[line_index]
              visible[input.size - input_index - 1][line.size - line_index - 1] = 1
              visible_bottom[line_index] = tree
            end
          end
        end

        visible
      end

      def score(tree, next_trees)
        next_tree_index = next_trees.find_index { |i| tree <= i }
        next_tree_index ? next_tree_index + 1 : next_trees.size
      end

      memoize def parse_input
        get_input.split("\n").map { |line| line.chars.map &:to_i }
      end

      def get_test_input(number)
        <<~TEST
          30373
          25512
          65332
          33549
          35390
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 8
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D08.new(test: false)
  today.run
end
