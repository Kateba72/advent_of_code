# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D13 < Solution

      def part1
        input = get_input
        input.sum do |pattern|
          rows = pattern.split("\n")
          row_mirror = find_p1_mirror(rows)
          next 100 * row_mirror if row_mirror
          cols = (0...rows[0].size).map do |i|
            rows.map { |r| r[i] }.join
          end
          find_p1_mirror(cols)
        end
      end

      def find_p1_mirror(arr)
        mirror = arr[...-1].find_index.with_index do |line, index|
          if line == arr[index + 1]
            top = arr[...index]
            bottom = arr[index + 2..].reverse
            size = [top.size, bottom.size].min
            top.last(size) == bottom.last(size)
          end
        end
        mirror + 1 if mirror
      end

      def part2
        input = get_input
        input.sum do |pattern|
          rows = pattern.split("\n")
          row_mirror = find_p2_mirror(rows)
          next 100 * row_mirror if row_mirror
          cols = (0...rows[0].size).map do |i|
            rows.map { |r| r[i] }.join
          end
          find_p2_mirror(cols)
        end
      end

      def find_p2_mirror(arr)
        mirror = arr[0...-1].find_index.with_index do |_, index|
          top = arr[..index]
          bottom = arr[index + 1..].reverse
          size = [top.size, bottom.size].min
          top = top.last(size)
          bottom = bottom.last(size)
          smudge = false
          top.zip(bottom).all? do |t, b|
            next true if t == b
            next false if smudge
            t.chars.zip(b.chars).all? do |tc, bc|
              next true if tc == bc
              next false if smudge
              smudge = true
              true
            end
          end && smudge
        end
        mirror + 1 if mirror
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n\n")
      end

      def get_test_input(number)
        <<~TEST
          #.##..##.
          ..#.##.#.
          ##......#
          ##......#
          ..#.##.#.
          ..##..##.
          #.#.##.#.

          #...##..#
          #....#..#
          ..##..###
          #####.##.
          #####.##.
          ..##..###
          #....#..#
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 13
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D13.new(test: false)
  today.run
end
