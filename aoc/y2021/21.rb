require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  players = get_input

  round = 0
  scores = [0, 0]
  loop do
    player_index = round % 2
    players[player_index] = (players[player_index] + 9 * round + 5) % 10 + 1
    round += 1
    scores[player_index] += players[player_index]
    break if scores[player_index] >= 1000
  end
  puts round * 3 * scores.min
end

def part2
  puts 'Part 2:'
  players = get_input

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

  puts winning_states
  puts
  puts winning_states.max

end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 21)
  input.split("\n")
  p1 = input.match(/Player 1 starting position: (\d+)/)[1].to_i
  p2 = input.match(/Player 2 starting position: (\d+)/)[1].to_i
  [p1, p2]
end

def get_test_input(number)
  <<~TEST
Player 1 starting position: 4
Player 2 starting position: 8
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
