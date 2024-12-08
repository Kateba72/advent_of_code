require_relative '../solution'

module AoC
  module Y2020
    class D08 < Solution

      def part1
        input = parse_input

        run_program(input)[0]
      end

      def part2
        input = parse_input

        input.each_with_index do |instruction, index|
          next if instruction[0] == 'acc'

          result = run_program(input, index)
          next if result[1]

          break result[0]
        end
      end

      def run_program(input, switched = nil)
        acc = 0
        pos = 0
        visited = Set.new

        while visited.exclude?(pos) && pos < input.size
          visited << pos

          instruction = input[pos]

          if pos == switched
            instruction = instruction.dup
            instruction[0] = instruction[0] == 'nop' ? 'jmp' : 'nop'
          end

          next_pos = pos + 1

          case instruction[0]
          when 'nop'
            # nop
          when 'acc'
            acc += instruction[1].to_i
          when 'jmp'
            next_pos = pos + instruction[1].to_i
          end

          pos = next_pos
        end

        [acc, visited.include?(pos)]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map(&:split)
      end

      def get_test_input(_number)
        <<~TEST
          nop +0
          acc +1
          jmp +4
          acc +3
          jmp -3
          acc -99
          acc +1
          jmp -4
          acc +6
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 8
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D08.new(test: test)
  today.run
end
