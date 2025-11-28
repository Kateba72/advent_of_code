require_relative '../solution'
require_relative 'intcode'

# https://adventofcode.com/2019/day/2
module AoC
  module Y2019
    class D02 < Solution

      def part1
        program = parse_input.dup

        unless testing?
          program[1] = 12
          program[2] = 2
        end

        intcode = Intcode.new(program, testing: testing?)
        intcode.run

        intcode.program[0]
      end

      def part2
        program = parse_input

        noun, verb = (0..99).to_a.product((0..99).to_a).find do |noun, verb|
          intcode = Intcode.new(program)
          intcode.program[1] = noun
          intcode.program[2] = verb
          intcode.run

          intcode.program[0] == 19_690_720
        end

        100 * noun + verb
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split(',').map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          1,9,10,3,2,3,11,0,99,30,40,50
        TEST
      end

      AOC_YEAR = 2019
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2019::D02.new(test: test)
  today.run
end
