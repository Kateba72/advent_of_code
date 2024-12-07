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

      def recursive_combat(p1, p2, recursion=0)
        seen_gamestates = Set.new

        while p1.present? && p2.present?
          return [true, p1] if seen_gamestates.include? [p1, p2]
          seen_gamestates << [p1.dup, p2.dup]

          c1 = p1.shift
          c2 = p2.shift

          p1_wins = if c1 <= p1.size && c2 <= p2.size
            p1_copy = p1[...c1]
            p2_copy = p2[...c2]
            recursive_combat(p1_copy, p2_copy, recursion + 1)[0]
          else
            c1 > c2
          end

          if p1_wins
            p1 << c1
            p1 << c2
          else
            p2 << c2
            p2 << c1
          end
        end

        return [p1.present?, p1.presence || p2]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        players = get_input.split("\n\n")
        players.map do
          _1.split("\n")[1..].map(&:to_i)
        end
      end

      def get_test_input(number)
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
