require_relative '../solution'

# https://adventofcode.com/2024/day/25
module AoC
  module Y2024
    class D25 < Solution

      def part1
        input = parse_input

        locks = []
        keys = []

        input.each do |schematic|
          if schematic.at(Vector[0, 0]) == '#'
            locks << schematic.columns.map { |col| col.index('.') }
          else
            keys << schematic.columns.map { |col| col.reverse.index('.') }
          end
        end

        height = input[0].height

        locks.sum do |lock|
          keys.count do |key|
            lock.zip(key).all? { |l, k| l + k <= height }
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n\n").map { Grid2d.from_string(_1) }
      end

      def get_test_input(_number)
        <<~TEST
          #####
          .####
          .####
          .####
          .#.#.
          .#...
          .....

          #####
          ##.##
          .#.##
          ...##
          ...#.
          ...#.
          .....

          .....
          #....
          #....
          #...#
          #.#.#
          #.###
          #####

          .....
          .....
          #.#..
          ###..
          ###.#
          ###.#
          #####

          .....
          .....
          .....
          #....
          #.#..
          #.#.#
          #####
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 25
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D25.new(test: test)
  today.run
end
