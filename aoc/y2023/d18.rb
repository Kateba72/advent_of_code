require_relative '../base_class'
require_relative '../shared/grid2d'

module AoC
  module Y2023
    class D18 < BaseClass

      def part1
        input = get_input

        lines = input.map do |line|
          dir, cnt, _col = line.split
          direction = case dir
          when 'R'
            Grid2d::DIRECTIONS[3]
          when 'U'
            Grid2d::DIRECTIONS[1]
          when 'L'
            Grid2d::DIRECTIONS[2]
          when 'D'
            Grid2d::DIRECTIONS[4]
          end

          [direction, cnt.to_i]
        end

        calculate_area(lines)
      end

      def part2
        input = get_input
        lines = input.map do |line|
          col = line.split[2]
          dir = { '0' => 3, '1' => 4, '2' => 2, '3' => 1 }[col[7]]
          cnt = col[2..6].to_i(16)
          [Grid2d::DIRECTIONS[dir], cnt]
        end

        calculate_area(lines)
      end

      def calculate_area(lines)
        pos = lines[0][0] * (lines[0][1])

        inside_area = lines.each_with_index.sum do |line, index|
          next 0 if index == 0 || index == lines.size - 1
          vector = line[0] * line[1]
          area = vector.cross_product.inner_product(pos)
          pos += vector
          area
        end.abs / 2
        line_area = lines.sum { |line| line[1] }
        inside_area + (line_area / 2) + 1
      end

      memoize def angle(v1, v2)
        v1.cross_product.inner_product(v2)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n")
      end

      def get_test_input(number)
        <<~TEST
          R 6 (#70c710)
          D 5 (#0dc571)
          L 2 (#5713f0)
          D 2 (#d2c081)
          R 2 (#59c680)
          D 2 (#411b91)
          L 5 (#8ceee2)
          U 2 (#caa173)
          L 1 (#1b58a2)
          U 2 (#caa171)
          R 2 (#7807d2)
          U 3 (#a77fa3)
          L 2 (#015232)
          U 2 (#7a21e3)
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 18
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D18.new(test: false)
  today.run
end
