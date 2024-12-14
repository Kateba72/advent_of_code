require_relative '../solution'

# https://adventofcode.com/2020/day/24
module AoC
  module Y2020
    class D24 < Solution

      ADJACIENT = [
        Vector[1, 1],
        Vector[1, -1],
        Vector[0, 2],
        Vector[0, -2],
        Vector[-1, 1],
        Vector[-1, -1],
      ].freeze

      LIVE = [2, 11, 12].freeze

      def part1
        input = parse_input

        flipped = Set.new
        input.each do |line|
          pos = Vector[0, 0]
          modifier = 2
          line.chars.each do |ch|
            pos += case ch
            when 's'
              Vector[1, 0]
            when 'n'
              Vector[-1, 0]
            when 'e'
              Vector[0, modifier]
            when 'w'
              Vector[0, -modifier]
            end
            modifier = 'ew'.include?(ch) ? 2 : 1
          end

          if flipped.include?(pos)
            flipped.delete(pos)
          else
            flipped << pos
          end
        end
        @flipped_start = flipped

        flipped.size
      end

      def part2
        state = @flipped_start

        100.times do
          state = conway_hex(state)
        end

        state.size
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def conway_hex(flipped)
        adjacients = Hash.new { 0 }

        flipped.each do |tile|
          ADJACIENT.each do |dir|
            adjacients[tile + dir] += 1
          end

          adjacients[tile] += 10
        end

        adjacients.filter { |_k, v| LIVE.include? v }.keys
      end

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          sesenwnenenewseeswwswswwnenewsewsw
          neeenesenwnwwswnenewnwwsewnenwseswesw
          seswneswswsenwwnwse
          nwnwneseeswswnenewneswwnewseswneseene
          swweswneswnenwsewnwneneseenw
          eesenwseswswnenwswnwnwsewwnwsene
          sewnenenenesenwsewnenwwwse
          wenwwweseeeweswwwnwwe
          wsweesenenewnwwnwsenewsenwwsesesenwne
          neeswseenwwswnwswswnw
          nenwswwsewswnenenewsenwsenwnesesenew
          enewnwewneswsewnwswenweswnenwsenwsw
          sweneswneswneneenwnewenewwneswswnese
          swwesenesewenwneswnwwneseswwne
          enesenwswwswneneswsenwnewswseenwsese
          wnwnesenesenenwwnenwsewesewsesesew
          nenewswnwewswnenesenwnesewesw
          eneswnwswnwsenenwnwnwwseeswneewsenese
          neswnwewnwnwseenwseesewsenwsweewe
          wseweeenwnesenwwwswnew
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 24
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D24.new(test: test)
  today.run
end
