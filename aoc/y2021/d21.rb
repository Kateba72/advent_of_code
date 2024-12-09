require_relative '../solution'

module AoC
  module Y2021
    class D21 < Solution

      def part1
        players = parse_input

        round = 0
        scores = [0, 0]
        loop do
          player_index = round % 2
          players[player_index] = (players[player_index] + 9 * round + 5) % 10 + 1
          round += 1
          scores[player_index] += players[player_index]
          break if scores[player_index] >= 1000
        end
        round * 3 * scores.min
      end

      def part2
        players = parse_input

        die_outcome = Hash.new(0)
        outcomes = [1, 2, 3]
        outcomes.product(outcomes).product(outcomes).each do |d12, d3|
          die_outcome[d12.sum + d3] += 1
        end

        player_states = [Hash.new(0), Hash.new(0)]
        player_states[0][[players[0], 0]] = 1
        player_states[1][[players[1], 0]] = 1
        winning_states = [0, 0]
        round = 0
        last_player_mverses = 1
        loop do
          this_player_mverses = 0
          player_index = round % 2
          new_scores = Hash.new(0)

          player_states[player_index].each do |state, mverses_player|
            field, score = state

            die_outcome.each do |die, mverses_die|
              new_field = (field + die - 1) % 10 + 1
              new_score = score + new_field
              mverses = mverses_player * mverses_die
              if new_score < 21
                new_scores[[new_field, new_score]] += mverses
                this_player_mverses += mverses
              else
                winning_states[player_index] += mverses * last_player_mverses
              end

            end
          end

          break if new_scores.blank?

          round += 1
          player_states[player_index] = new_scores
          last_player_mverses = this_player_mverses
        end

        winning_states.max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        input = get_input
        p1 = input.match(/Player 1 starting position: (\d+)/)[1].to_i
        p2 = input.match(/Player 2 starting position: (\d+)/)[1].to_i
        [p1, p2]
      end

      def get_test_input(_number)
        <<~TEST
          Player 1 starting position: 4
          Player 2 starting position: 8
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 21
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D21.new(test: false)
  today.run
end
