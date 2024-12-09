require_relative '../solution'

module AoC
  module Y2022
    class D15 < Solution

      def part1
        lines = parse_input
        y = @test || @test_input ? 10 : 2_000_000
        allowed_places = RangeGroup.new
        beacons = Set.new

        lines.each do |line|
          sensor, beacon = line
          distance = sensor.manhattan beacon
          covered_distance = distance - (sensor[1] - y).abs
          next if covered_distance < 0

          allowed_places.union! (sensor[0] - covered_distance)..(sensor[0] + covered_distance)
          beacons.add beacon if beacon[1] == y
        end

        allowed_places.size - beacons.size
      end

      def part2
        lines = parse_input
        max_coordinate = @test || @test_input ? 20 : 4_000_000

        # Differentiate between forward lines (/) and backward lines (\)
        # Forward lines have coordinate a=x+y, backward lines b=x-y
        # Get the forward lines that are just out of a beacon's range
        forward_lines = [max_coordinate]
        lines.each do |line|
          sensor, beacon = line
          distance = sensor.manhattan beacon
          forward_lines << sensor[0] + sensor[1] - distance - 1
          forward_lines << sensor[0] + sensor[1] - distance - 2
          forward_lines << sensor[0] + sensor[1] + distance + 1
          forward_lines << sensor[0] + sensor[1] + distance + 2
        end
        forward_lines = forward_lines.filter { |a| a >= 0 && a <= max_coordinate * 2 }.sort.uniq

        allowed_places = forward_lines.to_h do |a|
          max_b = [a, 2 * max_coordinate - a].min
          [a, RangeGroup.new(-max_b..max_b)]
        end

        lines.each do |line|
          sensor, beacon = line
          distance = sensor.manhattan beacon
          forward_lines.each do |a|
            next if sensor[0] + sensor[1] - distance > a
            next if sensor[0] + sensor[1] + distance < a

            b = sensor[0] - sensor[1]
            allowed_places[a].intersection! [-max_coordinate..(b - distance - 1), (b + distance + 1)..max_coordinate]
          end
        end

        return_value = 0
        allowed_places.each do |a, range|
          range.each do |b|
            next unless (a - b).even?

            x = (a + b) / 2
            y = (a - b) / 2
            return_value = 4_000_000 * x + y
          end
        end

        return_value
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/)
          [Vector[m[1].to_i, m[2].to_i], Vector[m[3].to_i, m[4].to_i]]
        end
      end

      def get_test_input(_number)
        <<~TEST
          Sensor at x=2, y=18: closest beacon is at x=-2, y=15
          Sensor at x=9, y=16: closest beacon is at x=10, y=16
          Sensor at x=13, y=2: closest beacon is at x=15, y=3
          Sensor at x=12, y=14: closest beacon is at x=10, y=16
          Sensor at x=10, y=20: closest beacon is at x=10, y=16
          Sensor at x=14, y=17: closest beacon is at x=10, y=16
          Sensor at x=8, y=7: closest beacon is at x=2, y=10
          Sensor at x=2, y=0: closest beacon is at x=2, y=10
          Sensor at x=0, y=11: closest beacon is at x=2, y=10
          Sensor at x=20, y=14: closest beacon is at x=25, y=17
          Sensor at x=17, y=20: closest beacon is at x=21, y=22
          Sensor at x=16, y=7: closest beacon is at x=15, y=3
          Sensor at x=14, y=3: closest beacon is at x=15, y=3
          Sensor at x=20, y=1: closest beacon is at x=15, y=3
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 15
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D15.new(test: false)
  today.run
end
