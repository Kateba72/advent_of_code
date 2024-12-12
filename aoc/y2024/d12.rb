require_relative '../solution'

# https://adventofcode.com/2024/day/12
module AoC
  module Y2024
    class D12 < Solution

      def part1
        grid = parse_input.deep_dup

        grid.with_coords.sum do |ch, coords|
          next 0 if ch.nil?

          region = []
          queue = Queue.new
          queue << coords
          perimeter = 0

          until queue.empty?
            field = queue.pop
            next if grid.at(field).nil?

            region << field
            grid.set_at(field, nil)

            Grid2d::NEIGHBORS.each do |direction|
              neighbor = field + direction
              if grid.at(neighbor) == ch
                queue << neighbor
              elsif region.exclude? neighbor
                perimeter += 1
              end
            end
          end

          perimeter * region.size
        end
      end

      def part2
        grid = parse_input.deep_dup

        grid.with_coords.sum do |ch, coords|
          next 0 if ch.nil?

          region = []
          fences = Grid2d::NEIGHBORS.index_with { [] }
          queue = Queue.new
          queue << coords

          until queue.empty?
            field = queue.pop
            next if grid.at(field).nil?

            region << field
            grid.set_at(field, nil)

            Grid2d::NEIGHBORS.each do |direction|
              neighbor = field + direction
              if grid.at(neighbor) == ch
                queue << neighbor
              elsif region.exclude? neighbor
                fences[direction] << field
              end
            end
          end

          sides = Grid2d::NEIGHBORS.sum do |direction|
            dir_fences = fences[direction]
            fence_continuation = Vector[direction[1], -direction[0]]

            dir_fences.count do |fence|
              dir_fences.exclude? fence + fence_continuation
            end
          end

          region.size * sides
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input)
      end

      def get_test_input(_number)
        <<~TEST
          RRRRIICCFF
          RRRRIICCCF
          VVRRRCCFFF
          VVRCCCJFFF
          VVVVCJJCFE
          VVIVCCJJEE
          VVIIICJJEE
          MIIIIIJJEE
          MIIISIJEEE
          MMMISSJEEE
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D12.new(test: test)
  today.run
end
