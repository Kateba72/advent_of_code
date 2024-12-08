require_relative '../solution'

module AoC
  module Y2024
    class D08 < Solution

      def part1
        input = parse_input
        antennas = {}

        antinode_locations = Set.new

        input.with_coords.each do |e, coords|
          next if e == '.'

          if antennas[e]
            antennas[e].each do |antenna|
              diff = antenna - coords

              location1 = antenna + diff
              location2 = coords - diff

              antinode_locations << location1 if input.in_bounds?(location1)
              antinode_locations << location2 if input.in_bounds?(location2)
            end

            antennas[e] << coords
          else
            antennas[e] = [coords]
          end
        end

        antinode_locations.size
      end

      def part2
        input = parse_input
        antennas = {}

        antinode_locations = Set.new

        input.with_coords.each do |e, coords|
          next if e == '.'

          if antennas[e]
            antinode_locations << antennas[e].first if antennas[e].size == 1
            antinode_locations << coords

            antennas[e].each do |antenna|
              diff = antenna - coords

              location = antenna + diff
              while input.in_bounds?(location)
                antinode_locations << location
                location += diff
              end

              location = coords - diff
              while input.in_bounds?(location)
                antinode_locations << location
                location -= diff
              end
            end

            antennas[e] << coords
          else
            antennas[e] = [coords]
          end
        end

        antinode_locations.size
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
          ............
          ........0...
          .....0......
          .......0....
          ....0.......
          ......A.....
          ............
          ............
          ........A...
          .........A..
          ............
          ............
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 8
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D08.new(test: test)
  today.run
end
