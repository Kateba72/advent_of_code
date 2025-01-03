require_relative '../solution'

module AoC
  module Y2021
    class D23 < Solution

      def part1
        input = parse_input 2

        find_shortest_path(input, 2)
      end

      def part2
        input = parse_input 4

        find_shortest_path(input, 4)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def find_shortest_path(positions, count)
        @next_moves = PriorityQueue.new
        @lowest_scores = {}
        @previous_positions = {}
        @next_moves << [0, 0, positions, 1]

        loop do
          _, score_until_now, positions, score_estimate = @next_moves.pop
          return score_until_now if score_estimate == 0 # this is the final position

          next if @lowest_scores[positions]&.< score_until_now

          occupied = [[], [], [], [], []]
          occupied[0][11] = nil
          next_distances = estimate_distance(positions, count)
          next_distances_sum = next_distances.sum
          (0...positions.size / 2).each do |amphipod|
            x = positions[2 * amphipod]
            y = positions[2 * amphipod + 1]
            occupied[x][y] = amphipod / count
          end
          (0...positions.size / 2).each do |amphipod|
            amphitype = amphipod / count
            x = positions[2 * amphipod]
            y = positions[2 * amphipod + 1]
            wants_y = amphitype * 2
            next if y == wants_y && (x == 2 || occupied[2][y] == amphitype)

            next if x > 1 && occupied[x - 1][y]
            next if x == 0 && occupied[1][wants_y]

            energy_per_move = 10**amphitype
            if x == 0
              hallway = wants_y > y ? (y + 1...wants_y) : (wants_y + 1...y)
              next if hallway.to_a.any? { |hallway_y| occupied[0][hallway_y] }

              room = (2..count).to_a.map { |room_x| occupied[room_x][wants_y] }
              next unless room.uniq.compact == [amphitype] || room.compact == []

              wants_x = (room.index { |e| e } || count - 1) + 1

              energy = energy_per_move * (hallway.size + 1 + wants_x)
              insert_next_point(amphipod, wants_x, wants_y, positions, score_until_now + energy, next_distances_sum - next_distances[amphipod])
            else
              (y + 1..8).each do |hallway_y|
                next unless hallway_y.odd? || hallway_y == 8
                break if occupied[0][hallway_y]

                energy = energy_per_move * (hallway_y - y + x)
                insert_next_point(amphipod, 0, hallway_y, positions, score_until_now + energy, next_distances_sum - next_distances[amphipod] + ((wants_y - hallway_y).abs + 1) * energy_per_move)
              end
              (-2...y).reverse_each do |hallway_y|
                next unless hallway_y.odd? || hallway_y == -2
                break if occupied[0][hallway_y]

                energy = energy_per_move * (y - hallway_y + x)
                insert_next_point(amphipod, 0, hallway_y, positions, score_until_now + energy, next_distances_sum - next_distances[amphipod] + ((wants_y - hallway_y).abs + 1) * energy_per_move)
              end
            end
          end
        end
      end

      def print_path(last_position)
        while last_position
          print_position(last_position)
          p last_position
          last_position = @previous_positions[last_position]
        end
      end

      def insert_next_point(amphipod, x, y, old_positions, score_until_next, estimate)
        positions = old_positions.dup
        positions[2 * amphipod] = x
        positions[2 * amphipod + 1] = y
        score_min_until_end = score_until_next + estimate
        return if @lowest_scores[positions]&.<= score_until_next

        @next_moves << [-score_min_until_end, score_until_next, positions, estimate]
        @lowest_scores[positions] = score_until_next
        @previous_positions[positions] = old_positions
      end

      def print_position(positions)
        str = <<~HOUSE.split("\n")
          #############
          #...........#
          ###.#.#.#.###
            #.#.#.#.#
            #.#.#.#.#
            #.#.#.#.#
            #########
        HOUSE
        (0...positions.size / 2).each do |a|
          x = positions[2 * a]
          y = positions[2 * a + 1]
          str[x + 1][y + 3] = (65 + a / 4).chr
        end
        puts str
        puts
      end

      def estimate_distance(positions, count)
        (0...positions.size / 2).map do |a|
          moves_y = positions[2 * a + 1] - a / count * 2
          next 0 if moves_y == 0

          (positions[2 * a] + moves_y.abs + 1) * (10**(a / count))
        end
      end

      def parse_input(lines)
        map = get_input.split("\n")
        if lines == 4
          map.insert(3, '  #D#C#B#A#')
          map.insert(4, '  #D#B#A#C#')
        end
        positions = []
        (1..lines).each do |x|
          (0..3).each do |primo_y|
            y_pos = 2 * primo_y
            y_real = 2 * primo_y + 3
            occupant = (map[x + 1][y_real].ord - 65) * lines
            occupant += 1 while positions[2 * occupant]
            positions[2 * occupant] = x
            positions[2 * occupant + 1] = y_pos
          end
        end
        positions
      end

      def get_test_input(_number)
        <<~TEST
          #############
          #...........#
          ###B#C#B#D###
            #A#D#C#A#
            #########
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 23
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D23.new(test: false)
  today.run
end
