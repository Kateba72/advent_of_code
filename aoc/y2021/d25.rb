require_relative '../solution'

module AoC
  module Y2021
    class D25 < Solution

      def part1
        field = parse_input

        (1..).find do
          field, moved = move(field)
          !moved
        end
      end

      def move(field)
        moved = false
        new_field = field.deep_dup
        field.each_with_index do |line, x|
          line.chars.each_with_index do |ch, y|
            if ch == '>' && line[(y + 1) % line.size] == '.'
              new_field[x][y] = '.'
              new_field[x][(y + 1) % line.size] = '>'
              moved = true
            end
          end
        end

        field = new_field.deep_dup
        field.each_with_index do |line, x|
          line.chars.each_with_index do |ch, y|
            if ch == 'v' && field[(x + 1) % field.size][y] == '.'
              new_field[x][y] = '.'
              new_field[(x + 1) % field.size][y] = 'v'
              moved = true
            end
          end
        end
        [new_field, moved]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        v...>>.vv>
        .vv>>.vv..
        >>.>v>...v
        >>v>>.>.v.
        v>v.vv.v..
        >.>>..v...
        .vv..>.>v.
        v.v..>>v.v
        ....v..v.>
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 25
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D25.new(test: false)
  today.run
end
