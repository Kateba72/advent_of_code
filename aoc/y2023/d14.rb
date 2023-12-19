# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D14 < Solution

      def part1
        rows = get_input
        cols = (0...rows[0].size).map do |i|
          line = rows.map { |r| r[i] }.join
          line.gsub /\.+O[.O]*/ do |moving|
            rocks = moving.count 'O'
            'O' * rocks + '.' * (moving.size - rocks)
          end
        end
        calc_load(cols)
      end

      def calc_load(arrangement)
        load = 0
        arrangement.each do |col|
          next_moving = col.index('O')
          while next_moving
            load += col.size - next_moving

            next_moving = col.index('O', next_moving + 1)
          end
        end
        load
      end

      def part2
        rows = get_input

        arrangement = (0...rows[0].size).map do |i|
          rows.map { |r| r[i] }.join
        end

        previous_spins = { arrangement => 0 }
        spins_reverse = { 0 => arrangement }

        final_arrangement = (1..).each do |i|
          new_arrangement = do_spin(arrangement)
          if previous_spins.has_key? new_arrangement
            loop_start = previous_spins[new_arrangement]
            loop_size = i - loop_start
            step = (1000000000 - loop_start) % loop_size + loop_start
            break spins_reverse[step]
          else
            previous_spins[new_arrangement] = i
            spins_reverse[i] = new_arrangement
          end
          arrangement = new_arrangement
        end

        calc_load final_arrangement
      end

      def do_spin(arrangement)
        4.times do
          rows = arrangement.map do |line|
            line.gsub /\.+O[.O]*/ do |moving|
              rocks = moving.count 'O'
              'O' * rocks + '.' * (moving.size - rocks)
            end
          end
          cols = (0...rows[0].size).map do |i|
            rows.map { |r| r[i] }.join
          end.reverse
          arrangement = cols
        end
        arrangement
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n")
      end

      def get_test_input(number)
        <<~TEST
          O....#....
          O.OO#....#
          .....##...
          OO.#O....O
          .O.....O#.
          O.#..O.#.#
          ..O..#O..O
          .......O..
          #....###..
          #OO..#....
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 14
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D14.new(test: false)
  today.run
end
