require_relative '../solution'

module AoC
  module Y2021
    class D15 < Solution

      def part1
        input = parse_input
        find_shortest_path(input)
      end

      def part2
        map = parse_input

        map.each do |line|
          original_size = line.size
          (0..3).each do |increase|
            (0..original_size - 1).each do |y|
              line << (line[y] + increase) % 9 + 1
            end
          end
        end

        original_size = map.size
        (0..3).each do |increase|
          (0..original_size - 1).each do |x|
            line = map[x].map do |entry|
              (entry + increase) % 9 + 1
            end
            map << line
          end
        end

        find_shortest_path(map)
      end

      def find_shortest_path(map)
        next_moves = PriorityQueue.new
        lowest_scores = {}
        calculate_distance_estimates(map)
        insert_next_point(1, 0, map, 0, next_moves, lowest_scores)
        insert_next_point(0, 1, map, 0, next_moves, lowest_scores)

        loop do
          _, score_until_now, x, y = next_moves.pop
          return score_until_now if x == map.size - 1 && y == map[0].size - 1

          next if lowest_scores[[x, y]]&.< score_until_now

          insert_next_point(x - 1, y, map, score_until_now, next_moves, lowest_scores)
          insert_next_point(x, y - 1, map, score_until_now, next_moves, lowest_scores)
          insert_next_point(x + 1, y, map, score_until_now, next_moves, lowest_scores)
          insert_next_point(x, y + 1, map, score_until_now, next_moves, lowest_scores)
        end
      end

      def insert_next_point(x, y, map, score_until_now, next_moves, lowest_scores)
        return if x < 0 || y < 0 || x >= map.size || y >= map[0].size

        score_until_next = score_until_now + map[x][y]
        score_min_until_end = @distance_estimates[x][y] + score_until_now
        return if lowest_scores[[x, y]]&.<= score_until_next

        next_moves << [-score_min_until_end, score_until_next, x, y]
        lowest_scores[[x, y]] = score_until_next
      end

      def calculate_distance_estimates(map)
        @distance_estimates = []
        last_row = map.size - 1
        last_column = map[0].size - 1
        last_diagonal = last_row + last_column

        (0..last_row).each do |row|
          @distance_estimates[row] = []
        end
        @distance_estimates[last_row][last_column] = map[last_row][last_column]

        (0..last_diagonal - 1).reverse_each do |diagonal|
          diagonal_value = Float::INFINITY
          column_range = [0, diagonal - last_row].max..[last_column, diagonal].min

          column_range.each do |column|
            row = diagonal - column
            # When we are on row R, column C in diagonal D=R+C, we either go to diagonal D+1
            # or we go back, but then return later to diagonal D. Take Manhattan distance to
            # that other point in diagonal D.
            # All points left/down in the diagonal are considered now, the points up/right
            # will be considered in the next loop
            this_point_estimate = @distance_estimates[row][column] = [
              @distance_estimates[row][column + 1] || Float::INFINITY,
              @distance_estimates[row + 1]&.at(column) || Float::INFINITY,
              diagonal_value + 2,
            ].min + map[row][column]
            diagonal_value = diagonal_value + 2 < this_point_estimate ? diagonal_value + 1 : this_point_estimate
          end

          diagonal_value = Float::INFINITY
          column_range.reverse_each do |column|
            row = diagonal - column
            this_point_estimate = @distance_estimates[row][column] = [
              @distance_estimates[row][column],
              diagonal_value + 2 + map[row][column],
            ].min
            diagonal_value = diagonal_value + 2 < this_point_estimate ? diagonal_value + 1 : this_point_estimate
          end
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        get_input.split("\n").map do |line|
          line.chars.map(&:to_i)
        end
      end

      def get_test_input(_number)
        <<~TEST
          1163751742
          1381373672
          2136511328
          3694931569
          7463417111
          1319128137
          1359912421
          3125421639
          1293138521
          2311944581
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 15
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D15.new(test: false)
  today.run
end
