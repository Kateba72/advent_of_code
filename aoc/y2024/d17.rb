require_relative '../solution'

# https://adventofcode.com/2024/day/17
module AoC
  module Y2024
    class D17 < Solution

      def part1
        registers, program = parse_input

        next_instruction = 0
        outputs = []

        loop do
          instruction = next_instruction
          arg = program[instruction + 1]
          next_instruction = instruction + 2
          case program[instruction]
          when 0 # adv
            registers[0] = registers[0] >> combo(arg, registers)
          when 1 # bxl
            registers[1] ^= arg
          when 2 # bst
            registers[1] = combo(arg, registers) % 8
          when 3 # jnz
            next if registers[0] == 0

            next_instruction = arg
          when 4 # bxc
            registers[1] ^= registers[2]
          when 5 # out
            outputs << combo(arg, registers) % 8
          when 6 # bdv
            registers[1] = registers[0] >> combo(arg, registers)
          when 7 # cdv
            registers[2] = registers[0] >> combo(arg, registers)
          when nil
            break # end of program
          end
        end

        outputs.join(',')
      end

      def part2
        _registers, program = parse_input

        try_part2(0, 15, program)
      end

      def try_part2(in_a, instruction, program)
        # This is what my input was doing:
        # while a > 0
        #   b = a % 8 ^ 1  # take the last 3 bytes of a
        #   c = a >> b % 8 # find something in the previous bytes of a
        #   out b ^ 5 ^ c  # complicated way to calculate wanted output
        #   a >> 3         # right-shift a by 3
        #                  # This means that every byte of a is used exactly once
        # end
        #
        # Start from the highest bytes of a (instruction = 15) and work recursively down
        return in_a if instruction < 0

        wanted_output = program[instruction]
        in_a <<= 3
        (0..7).each do |these_bytes|
          this_a = in_a + these_bytes
          # this only happens for the first loop (instruction = 15, these_bytes = 0)
          # Ensure that "while a > 0" is not satisfied earlier
          next if this_a == 0

          b = these_bytes ^ 1
          c = this_a >> b
          out = b ^ 5 ^ c % 8
          next unless wanted_output == out

          result = try_part2(this_a, instruction - 1, program)
          return result if result
        end

        false
      end

      def combo(x, registers)
        if x <= 3
          x
        else
          registers[x - 4]
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        registers, program = get_input.split("\n\n")
        [registers.integers, program.integers]
      end

      def get_test_input(_number)
        <<~TEST
          Register A: 729
          Register B: 0
          Register C: 0

          Program: 0,1,5,4,3,0
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 17
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D17.new(test: test)
  today.run
end
