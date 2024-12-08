require_relative '../solution'

module AoC
  module Y2022
    class D24 < Solution

      NEIGHBORS = Grid2d::NEIGHBORS + [Vector[0, 0]]

      memoize def part1
        parse_input
        find_shortest_path(@start, @target)
      end

      def part2
        parse_input
        first_path = part1
        second_path = find_shortest_path(@target, @start, first_path)
        find_shortest_path(@start, @target, second_path)
      end

      def find_shortest_path(start, target, start_minute = 0)
        next_moves = PriorityQueue.new
        lowest_scores = {}
        next_moves << [start_minute, start_minute, start]
        map_size_lcm = @map_size[0].lcm(@map_size[1])
        lowest_scores[[start, start_minute % map_size_lcm]] = start_minute

        loop do
          _, score_until_now, pos = next_moves.pop
          return score_until_now if pos == target

          next if lowest_scores[[pos, score_until_now % map_size_lcm]]&.< score_until_now

          minute = score_until_now + 1
          normalized_minute = minute % map_size_lcm

          NEIGHBORS.each do |direction|
            neighbor = pos + direction
            value = @map.at(neighbor)
            next if value.in? ['#', nil]
            next unless neighbor == start || neighbor == target || accessible?(neighbor, normalized_minute)

            score_min_until_end = score_until_now + target.manhattan(neighbor)
            unless lowest_scores[[neighbor, normalized_minute]]&.<= minute
              next_moves << [-score_min_until_end, minute, neighbor]
              lowest_scores[[neighbor, normalized_minute]] = minute
            end
          end
        end
      end

      memoize def accessible?(pos, minute)
        (@map.at(inbound(pos + Grid2d::LEFT * minute)) != '>') &&
          (@map.at(inbound(pos + Grid2d::RIGHT * minute)) != '<') &&
          (@map.at(inbound(pos + Grid2d::UP * minute)) != 'v') &&
          (@map.at(inbound(pos + Grid2d::DOWN * minute)) != '^')
      end

      memoize def inbound(pos)
        pos.collect2(@map_size) do |p, size|
          (p - 1) % size + 1
        end
      end

      private

      memoize def parse_input
        map = Grid2d.from_string(get_input)
        @start = Vector[map.row(0).index('.'), 0]
        @target = Vector[map.row(-1).index('.'), map.height - 1]
        @map_size = Vector[map.width - 2, map.height - 2]
        @map = map
      end

      def get_test_input(_number)
        <<~TEST
          #.######
          #>>.<^<#
          #.<..<<#
          #>v.><>#
          #<^v^^>#
          ######.#
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 24
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D24.new(test: false)
  today.run
end
