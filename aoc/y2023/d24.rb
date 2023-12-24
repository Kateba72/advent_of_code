# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D24 < Solution

      def part1
        range = testing? ? 7..27 : 200000000000000..400000000000000

        hailstones = get_input

        intersections = 0
        hailstones.each_with_index do |hs_a, index_a|
          hailstones.each_with_index do |hs_b, index_b|
            next if index_a >= index_b
            intersection = intersect2d(*hs_a, *hs_b)
            if intersection && range.cover?(intersection[0]) && range.cover?(intersection[1])
              intersections += 1
            end
          end
        end

        intersections
      end

      def intersect2d(pos_a, vel_a, pos_b, vel_b)
        det = vel_a[0] * vel_b[1] - vel_b[0] * vel_a[1]
        if det != 0
          invmat = Matrix[[vel_b[1], -vel_b[0]], [-vel_a[1], vel_a[0]]]
          times = invmat * Vector[pos_b[0] - pos_a[0], pos_b[1] - pos_a[1]]
          return false if (det > 0 ? times[0] < 0 || times[1] > 0 : times[0] > 0 || times[1] < 0)
          pos_a + times[0] * vel_a / det
        else
          diff_x = pos_b[0] - pos_a[0]
          time = diff_x / (vel_a[0] - vel_b[0])
          possible_intersection = pos_a + time * vel_a
          return false if possible_intersection[1] != pos_b[1] + time * vel_b[1]
          'same_line'
        end
      end

      def part2
        input = get_input

        hs_a = input.pop

        (0..).each do |max|
          (-max...max).each do |other|

            result = check_vel(Vector[max, other, 0], hs_a, input) ||
              check_vel(Vector[-other, max, 0], hs_a, input) ||
              check_vel(Vector[-max, -other, 0], hs_a, input) ||
              check_vel(Vector[other, -max, 0], hs_a, input)

            if result
              return result
            end
          end
        end

      end

      def check_vel(vel, hs_a, hailstones)
        first_pos = nil
        hailstones.each do |hs_b|
          first_pos = intersect2d(hs_a[0], hs_a[1] - vel, hs_b[0], hs_b[1] - vel)
          return unless first_pos # no intersection => invalid velocity
          break unless first_pos == 'same_line' # there is no one intersection point, search for another
        end

        times = hailstones.map do |hs_b|
          time = find_time(hs_b, vel, first_pos)
          return false unless time
          time
        end
        time_a = find_time(hs_a, vel, first_pos)

        if (z = find_z(times, time_a))
          first_pos[0] + first_pos[1] + z
        end
      end

      def find_time(hs_b, vel, first_pos)
        rel_vel = hs_b[1] - vel
        time = if rel_vel[0] != 0
          diff_x = first_pos[0] - hs_b[0][0]
          time = diff_x / rel_vel[0]
          return false if hs_b[0][1] + time * rel_vel[1] != first_pos[1]
          time
        else
          return false if hs_b[0][0] != first_pos[0]
          return false if rel_vel[1] == 0 # this hailstone would be either on the rock (and would therefore not hit anything) or parallel (and not be hit by the rock)
          diff_y = first_pos[1] - hs_b[0][1]
          diff_y / rel_vel[1]
        end
        return false if time < 0
        [time, hs_b]
      end

      def find_z(times, time_a)
        time_b = times.find { |time| time[1][1][2] != time_a[1][1][2] && time[0] != time_a[0] }

        orig_a = time_a[1][0][2] + time_a[1][1][2] * time_a[0]
        orig_b = time_b[1][0][2] + time_b[1][1][2] * time_b[0]

        vz = (orig_a - orig_b) / (time_a[0] - time_b[0])
        z = orig_a - vz * time_a[0]

        return false unless times.all? do |time|
          time[1][0][2] + (time[1][1][2] - vz) * time[0] == z
        end

        z
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        lines = super.split("\n")
        lines.map do |line|
          pos, vel = line.split(' @ ')
          pos = Vector[*pos.split(', ').map(&:to_i)]
          vel = Vector[*vel.split(', ').map(&:to_i)]
          [pos, vel]
        end
      end

      def get_test_input(number)
        <<~TEST
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 24
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D24.new(test: false)
  today.run
end
