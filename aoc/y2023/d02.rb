require_relative '../solution'

module AoC
  module Y2023
    class D02 < Solution

      def part1
        input = parse_input
        input.sum do |line|
          game_info, infos = line.split(': ')
          game_no = game_info.split[1].to_i
          if infos.split(/[,;] /).all? do |info|
            count, color = info.split
            count = count.to_i
            (color == 'red' && count <= 12) || (color == 'green' && count <= 13) || (color == 'blue' && count <= 14)
          end
            game_no
          else
            0
          end
        end
      end

      def part2
        input = parse_input
        input.sum do |line|
          _game_info, infos = line.split(':')
          %w[red green blue].map do |color|
            infos.scan(/ (\d+) #{color}/).map { |m| m[0].to_i }.max
          end.inject(:*)
        end
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
          Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
          Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
          Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
          Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 2
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D02.new(test: false)
  today.run
end
