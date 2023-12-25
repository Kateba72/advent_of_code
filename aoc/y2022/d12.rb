require_relative '../solution'

module AoC
  module Y2022
    class D12 < Solution

      def part1
        map, start, target = parse_input

        next_moves = PriorityQueue.new
        lowest_scores = {}
        next_moves << [0, 0, start[0], start[1]]
        lowest_scores[[start[0], start[1]]] = 0

        loop do
          _, score_until_now, x, y = next_moves.pop
          if [x, y] == target
            return score_until_now
          end

          next if lowest_scores[[x, y]]&.< score_until_now

          map.neighbors_with_indexes(x, y).each do |value, nx, ny|
            next if value.ord > map[x][y].ord + 1
            score_until_next = score_until_now + 1
            score_min_until_end = score_until_now + 'z'.ord - value.ord
            unless lowest_scores[[nx, ny]]&.<= score_until_next
              next_moves << [-score_min_until_end, score_until_next, nx, ny]
              lowest_scores[[nx, ny]] = score_until_next
            end
          end
        end
      end

      def part2
        map, _start, target = parse_input

        next_moves = PriorityQueue.new
        lowest_scores = {}
        next_moves << [0, 0, target[0], target[1]]
        lowest_scores[[target[0], target[1]]] = 0

        loop do
          _, score_until_now, x, y = next_moves.pop
          if map[x][y] == 'a'
            return score_until_now
          end

          next if lowest_scores[[x, y]]&.< score_until_now

          map.neighbors_with_indexes(x, y).each do |value, nx, ny|
            next if value.ord < map[x][y].ord - 1
            score_until_next = score_until_now + 1
            score_min_until_end = score_until_now + value.ord - 'a'.ord
            unless lowest_scores[[nx, ny]]&.<= score_until_next
              next_moves << [-score_min_until_end, score_until_next, nx, ny]
              lowest_scores[[nx, ny]] = score_until_next
            end
          end
        end
      end

      private

      memoize def parse_input
        map = get_input.split("\n").map(&:chars)

        start, target = nil, nil
        map.each_with_index do |line, x|
          line.each_with_index do |char, y|
            if char == 'S'
              map[x][y] = 'a'
              start = [x, y]
            elsif char == 'E'
              map[x][y] = 'z'
              target = [x, y]
            end
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
