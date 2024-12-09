require_relative '../solution'

module AoC
  module Y2021
    class D04 < Solution

      def part1
        boards = parse_input
        winning_board = boards.min_by { |b| winning_move(b) }
        board_score(winning_board)
      end

      def part2
        boards = parse_input
        losing_board = boards.max_by { |b| winning_move(b) }
        board_score(losing_board)
      end

      memoize def winning_move(board)
        rows = board.rows.map do |row|
          row.map { |number| @numbers_reversed[number] }.max
        end
        cols = board.columns.map do |col|
          col.map { |number| @numbers_reversed[number] }.max
        end
        [*rows, *cols].min
      end

      def board_score(board)
        w = winning_move(board)
        board.grid.flatten.sum do |entry|
          @numbers_reversed[entry] > w ? entry : 0
        end * @numbers[w]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        numbers, *boards = get_input.split("\n\n")
        @numbers = numbers.split(',').map(&:to_i)
        @numbers_reversed = []
        @numbers.each_with_index { |number, order| @numbers_reversed[number] = order }

        boards.map do |board|
          Grid2d.new(board.split("\n").map(&:integers))
        end
      end

      def get_test_input(_number)
        <<~TEST
          7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

          22 13 17 11  0
           8  2 23  4 24
          21  9 14 16  7
           6 10  3 18  5
           1 12 20 15 19

           3 15  0  2 22
           9 18 13 17  5
          19  8  7 25 23
          20 11 10 24  4
          14 21 16 12  6

          14 21 17 24  4
          10 16 15  9 19
          18  8 23 26 20
          22 11 13  6  5
           2  0 12  3  7
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D04.new(test: false)
  today.run
end
