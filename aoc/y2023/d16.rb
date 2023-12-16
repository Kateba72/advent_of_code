require_relative '../base_class'
require_relative '../shared/grid2d'

module AoC
  module Y2023
    class D16 < BaseClass

      DIRECTIONS = Grid2d::DIRECTIONS

      def part1
        get_input
        energized(Vector[0, 0], 3)
      end

      def part2
        get_input

        @grid.edges.map do |position, direction|
          energized(position, direction)
        end.max
      end

      def energized(position, direction)
        visited = Set.new
        energized = Set.new
        locations = Queue.new
        locations << [position, direction]

        until locations.empty?
          pos, dir = locations.pop
          next if visited.include? [pos, dir]
          visited << [pos, dir]
          new_locations, new_energized = step(pos, dir)
          new_locations.each { |loc| locations << loc }
          energized |= new_energized
        end

        energized.size
      end

      memoize def step(position, direction)
        return [[], Set.new] unless @grid.in_bounds? position

        energized = Set.new([position])
        while @grid.at(position) == '.'
          position += DIRECTIONS[direction]
          return [[], energized] unless @grid.in_bounds? position
          energized << position
        end

        new_directions = case @grid.at(position)
        when '/'
          new_direction = { 1 => 3, 2 => 4, 3 => 1, 4 => 2}[direction]
          [new_direction]
        when "\\"
          new_direction = { 1 => 2, 2 => 1, 3 => 4, 4 => 3}[direction]
          [new_direction]
        when '-'
          if [2, 3].include? direction
            [direction]
          else
            [2, 3]
          end
        when '|'
          if [1, 4].include? direction
            [direction]
          else
            [1, 4]
          end
        else
          raise "Unknown char #{@grid.at(position)} at position #{position}"
        end

        new_positions = new_directions.map do |dir|
          [position + DIRECTIONS[dir], dir]
        end

        [new_positions, energized]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        @grid = Grid2d.new(super.split("\n"))
      end

      def get_test_input(number)
        <<~'TEST'
          .|...\....
          |.-.\.....
          .....|-...
          ........|.
          ..........
          .........\
          ..../.\\..
          .-.-/..|..
          .|....-|.\
          ..//.|....
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 16
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D16.new(test: false)
  today.run
end
