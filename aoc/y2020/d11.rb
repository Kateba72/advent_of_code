require_relative '../solution'

module AoC
  module Y2020
    class D11 < Solution

      def part1
        input = parse_input

        loop do
          after_step = model_step1(input)
          break if input.grid == after_step.grid

          input = after_step
        end

        input.count '#'
      end

      def part2
        input = parse_input

        loop do
          after_step = model_step2(input)
          break if input.grid == after_step.grid

          input = after_step
        end

        input.join.count '#'
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def model_step1(grid)
        after_step = grid.deep_dup
        grid.with_coords.each do |ch, coords|
          neighbors = Grid2d::NEIGHBORS_WITH_DIAGONALS.map { grid.at(_1 + coords) }.compact
          if ch == '#'
            after_step.set_at(coords, neighbors.count('#') >= 4 ? 'L' : '#')
          elsif ch == 'L'
            after_step.set_at(coords, neighbors.count('#') == 0 ? '#' : 'L')
          end
        end

        after_step
      end

      def model_step2(grid)
        after_step = grid.deep_dup
        grid.with_coords.each do |ch, coords|
          next if ch == '.'

          neighbors = Grid2d::NEIGHBORS_WITH_DIAGONALS.map { |dir| first_seat(grid, coords, dir) }
          if ch == '#'
            after_step.set_at(coords, neighbors.count('#') >= 5 ? 'L' : '#')
          elsif ch == 'L'
            after_step.set_at(coords, neighbors.count('#') == 0 ? '#' : 'L')
          end
        end

        after_step
      end

      def first_seat(grid, pos, dir)
        loop do
          pos += dir
          break unless grid.in_bounds? pos
          return lines.at(pos) if lines.at(pos) != '.'
        end
      end

      memoize def parse_input
        Grid2d.from_string(get_input)
      end

      def get_test_input(_number)
        <<~TEST
          L.LL.LL.LL
          LLLLLLL.LL
          L.L.L..L..
          LLLL.LL.LL
          L.LL.LL.LL
          L.LLLLL.LL
          ..L.L.....
          LLLLLLLLLL
          L.LLLLLL.L
          L.LLLLL.LL
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 11
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D11.new(test: false)
  today.run
end
