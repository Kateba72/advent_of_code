require_relative '../solution'

module AoC
  module Y2021
    class D09 < Solution

      def part1
        input = parse_input

        puts
        input.with_coords.sum do |risk, position|
          next 0 unless Grid2d::NEIGHBORS.all? do |neighbor|
            input.at(position + neighbor, 10) > risk
          end
          risk + 1
        end
      end

      def part2
        @input = parse_input
        basins = {}

        @input.with_coords.each do |risk, position|
          next if risk == 9

          b = basin(position)
          basins[b] ||= 0
          basins[b] += 1
        end

        largest = basins.values.sort.reverse
        largest[0] * largest[1] * largest[2]
      end

      memoize def basin(position)
        risk = @input.at(position)
        lower_neighbor = Grid2d::NEIGHBORS.find do |n|
          @input.at(position + n, 10) < risk
        end

        lower_neighbor ? basin(lower_neighbor + position) : position
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        Grid2d.from_string(get_input) { _1.to_i }
      end

      def get_test_input(number)
        <<~TEST
          2199943210
          3987894921
          9856789892
          8767896789
          9899965678
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 9
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D09.new(test: false)
  today.run
end
