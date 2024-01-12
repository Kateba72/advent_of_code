require_relative '../solution'

module AoC
  module Y2021
    class D17 < Solution

      def part1
        _x_range, y_range = parse_input

        # Maybe I was lucky, but both the example and the input had a range for x that
        # contained a triangle number. If you set x s.t. x_range covers x*(x+1), then
        # the probe will stay in the correct x range forever, giving the y value
        # enough time to make a nice parabola.
        # If you start with a positive y value, the parabola will reach height y * (y+1) / 2
        # and upon returning to y=0, the probe will have a velocity of -y_initial - 1
        # This velocity must not be smaller than the minimum of the range.
        # Therefore, the highest initial y velocity is
        max_y_initial = -y_range.begin - 1
        max_y_initial * (max_y_initial + 1) / 2
      end

      def part2
        x_range, y_range = parse_input

        x_initial = get_min_x_initial(x_range) .. x_range.end
        y_initial = y_range.begin .. -y_range.begin-1

        x_initial.to_a.product(y_initial.to_a).filter { |x, y| velocity_covers?(x_range, y_range, Vector[x, y]) }.count
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_min_x_initial(x_range)
        start = Math.sqrt(x_range.begin * 2).ceil
        until x_range.begin <= start * (start + 1) / 2
          start += 1
        end
        start
      end

      def velocity_covers?(x_range, y_range, velocity)
        position = Vector[0, 0]

        until position[0] > x_range.end || position[1] < y_range.begin
          position += velocity
          velocity[0] -= velocity[0] <=> 0
          velocity[1] -= 1
          return true if x_range.cover?(position[0]) && y_range.cover?(position[1])
        end

        false
      end

      def parse_input
        input = get_input

        input.match /^target area: x=(-?\d+)\.\.(=?\d+), y=(-?\d+)\.\.(-?\d+)$/ do |match|
          x_range = match[1].to_i .. match[2].to_i
          y_range = match[3].to_i .. match[4].to_i
          [x_range, y_range]
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 17
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D17.new(test: false)
  today.run
end
