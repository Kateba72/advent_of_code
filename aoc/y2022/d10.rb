require_relative '../solution'

module AoC
  module Y2022
    class D10 < Solution

      def calculate
        return if @calculated

        input = parse_input

        cycle = 1
        x = 1

        @signal_strength = 0
        @display = [nil] * 240

        input.each do |line|
          case line
          when 'noop'
            save_cycle(cycle, x)
            cycle += 1
          when /^addx (-?\d+)$/
            save_cycle(cycle, x)
            save_cycle(cycle + 1, x)
            x += $1.to_i
            cycle += 2
          end
        end

        @calculated = true
      end

      def part1
        calculate
        @signal_strength
      end

      def part2
        calculate
        @display.each_slice(40).map(&:join).join "\n"
      end

      private

      def save_cycle(cycle, x)
        @signal_strength += cycle * x if cycle % 40 == 20

        column = (cycle - 1) % 40 + 1
        @display[cycle - 1] = column >= x && column <= x + 2 ? '█' : ' '
      end

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          addx 15
          addx -11
          addx 6
          addx -3
          addx 5
          addx -1
          addx -8
          addx 13
          addx 4
          noop
          addx -1
          addx 5
          addx -1
          addx 5
          addx -1
          addx 5
          addx -1
          addx 5
          addx -1
          addx -35
          addx 1
          addx 24
          addx -19
          addx 1
          addx 16
          addx -11
          noop
          noop
          addx 21
          addx -15
          noop
          noop
          addx -3
          addx 9
          addx 1
          addx -3
          addx 8
          addx 1
          addx 5
          noop
          noop
          noop
          noop
          noop
          addx -36
          noop
          addx 1
          addx 7
          noop
          noop
          noop
          addx 2
          addx 6
          noop
          noop
          noop
          noop
          noop
          addx 1
          noop
          noop
          addx 7
          addx 1
          noop
          addx -13
          addx 13
          addx 7
          noop
          addx 1
          addx -33
          noop
          noop
          noop
          addx 2
          noop
          noop
          noop
          addx 8
          noop
          addx -1
          addx 2
          addx 1
          noop
          addx 17
          addx -9
          addx 1
          addx 1
          addx -3
          addx 11
          noop
          noop
          addx 1
          noop
          addx 1
          noop
          noop
          addx -13
          addx -19
          addx 1
          addx 3
          addx 26
          addx -30
          addx 12
          addx -1
          addx 3
          addx 1
          noop
          noop
          noop
          addx -9
          addx 18
          addx 1
          addx 2
          noop
          noop
          addx 9
          noop
          noop
          noop
          addx -1
          addx 2
          addx -37
          addx 1
          addx 3
          noop
          addx 15
          addx -21
          addx 22
          addx -6
          addx 1
          noop
          addx 2
          addx 1
          noop
          addx -10
          noop
          noop
          addx 20
          addx 1
          addx 2
          addx 2
          addx -6
          addx -11
          noop
          noop
          noop
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 10
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D10.new(test: false)
  today.run
end
