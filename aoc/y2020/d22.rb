require_relative '../solution'

module AoC
  module Y2020
    class D22 < Solution

      def part1
        player1, player2 = parse_input.deep_dup
        while player1.present? && player2.present?
          c1 = player1.shift
          c2 = player2.shift

          if c1 > c2
            player1 << c1
            player1 << c2
          else
            player2 << c2
            player2 << c1
          end
        end

        winning = player1.present? ? player1 : player2
        winning.zip(winning.size.downto(1)).sum { |card, multiplier| card * multiplier }
      end

      def part2
        player1, player2 = parse_input

        winning = recursive_combat(player1, player2)[1]
        winning.zip(winning.size.downto(1)).sum { |card, multiplier| card * multiplier }
      end

      def recursive_combat(player1, player2, recursion = 0)
        seen_gamestates = Set.new

        while player1.present? && player2.present?
          return [true, player1] if seen_gamestates.include? [player1, player2]

          seen_gamestates << [player1.dup, player2.dup]

          c1 = player1.shift
          c2 = player2.shift

          player1_wins = if c1 <= player1.size && c2 <= player2.size
            player1_copy = player1[...c1]
            player2_copy = player2[...c2]
            recursive_combat(player1_copy, player2_copy, recursion + 1)[0]
          else
            c1 > c2
          end

          if player1_wins
            player1 << c1
            player1 << c2
          else
            player2 << c2
            player2 << c1
          end
        end

        [player1.present?, player1.presence || player2]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        players = get_input.split("\n\n")
        players.map do |player|
          player.split("\n")[1..].map(&:to_i)
        end
      end

      def get_test_input(_number)
        <<~TEST
          Player 1:
          9
          2
          6
          3
          1

          Player 2:
          5
          8
          4
          7
          10
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 22
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D22.new(test: test)
  today.run
end
