require_relative '../solution'

module AoC
  module Y2022
    class D05 < Solution

      def part1
        stacks, instructions = parse_input
        stacks = stacks.deep_dup
        instructions.map do |instruction|
          stacks = apply_instruction_9000 stacks, instruction
        end
        stacks.map(&:last).join
      end

      def part2
        stacks, instructions = parse_input
        stacks = stacks.deep_dup
        instructions.map do |instruction|
          stacks = apply_instruction_9001 stacks, instruction
        end
        stacks.map(&:last).join
      end

      private

      def apply_instruction_9000(stacks, instruction)
        instruction[0].times do
          item = stacks[instruction[1]].pop
          stacks[instruction[2]].append item
        end
        stacks
      end

      def apply_instruction_9001(stacks, instruction)
        item = stacks[instruction[1]].pop instruction[0]
        stacks[instruction[2]].append(*item)
        stacks
      end

      memoize def parse_input
        stack_text, instructions = get_input.split("\n\n")
        stack_lines = stack_text.split("\n").reverse
        stacks_count = stack_lines.first.scan(/\d+/).last.to_i
        stacks = (0...stacks_count).map do |i|
          stack = stack_lines[1..].map { _1[i * 4 + 1] }.compact
          stack.delete ' '
          stack
        end
        instructions = instructions.split("\n").map do |line|
          m = line.match(/^move (\d+) from (\d+) to (\d+)$/)
          [m[1].to_i, m[2].to_i - 1, m[3].to_i - 1]
        end
        [stacks, instructions]
      end

      def get_test_input(_number)
        <<~TEST
              [D]#{'    '}
          [N] [C]#{'    '}
          [Z] [M] [P]
           1   2   3#{' '}

          move 1 from 2 to 1
          move 3 from 1 to 3
          move 2 from 2 to 1
          move 1 from 1 to 2
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 5
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D05.new(test: false)
  today.run
end
