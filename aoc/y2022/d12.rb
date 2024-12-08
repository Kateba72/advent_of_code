require_relative '../solution'

module AoC
  module Y2022
    class D12 < Solution

      def part1
        map, start, target = parse_input

        next_moves = PriorityQueue.new
        lowest_scores = { start => 0 }
        next_moves << [0, 0, start]

        loop do
          _, score_until_now, pos = next_moves.pop
          break score_until_now if target == pos

          next if lowest_scores[pos]&.< score_until_now

          value = map.at(pos).ord
          Grid2d::NEIGHBORS.each do |direction|
            neighbor = pos + direction
            next unless map.in_bounds?(neighbor)

            value_neighbor = map.at(neighbor).ord
            next if value_neighbor > value + 1

            score_until_next = score_until_now + 1
            score_min_until_end = score_until_now + 'z'.ord - value_neighbor
            unless lowest_scores[neighbor]&.<= score_until_next
              next_moves << [-score_min_until_end, score_until_next, neighbor]
              lowest_scores[neighbor] = score_until_next
            end
          end
        end
      end

      def part2
        map, _start, target = parse_input

        next_moves = PriorityQueue.new
        lowest_scores = { target => 0 }
        next_moves << [0, 0, target]

        loop do
          _, score_until_now, pos = next_moves.pop
          break score_until_now if map.at(pos) == 'a'

          next if lowest_scores[pos]&.< score_until_now

          value = map.at(pos).ord
          Grid2d::NEIGHBORS.each do |direction|
            neighbor = pos + direction
            next unless map.in_bounds?(neighbor)

            value_neighbor = map.at(neighbor).ord
            next if value_neighbor.ord < value - 1

            score_until_next = score_until_now + 1
            score_min_until_end = score_until_now + value_neighbor.ord - 'a'.ord
            unless lowest_scores[neighbor]&.<= score_until_next
              next_moves << [-score_min_until_end, score_until_next, neighbor]
              lowest_scores[neighbor] = score_until_next
            end
          end
        end
      end

      private

      memoize def parse_input
        map = Grid2d.from_string(get_input)

        start = nil
        target = nil
        map.with_coords.each do |char, coords|
          if char == 'S'
            map.set_at(coords, 'a')
            start = coords
          elsif char == 'E'
            map.set_at(coords, 'z')
            target = coords
          end
        end

        [map, start, target]
      end

      def get_test_input(number)
        <<~TEST
          Sabqponm
          abcryxxl
          accszExk
          acctuvwj
          abdefghi
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D12.new(test: false)
  today.run
end
