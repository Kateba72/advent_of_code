require_relative '../solution'

module AoC
  module Y2020
    class D13 < Solution

      def part1
        earliest_time, departures = parse_input

        earliest_time = earliest_time.to_i

        options = departures.split(',').map do |bus|
          next if bus == 'x'

          wait_time = (-earliest_time) % bus.to_i
          [wait_time, bus.to_i]
        end.compact

        wait_time, bus = options.min { |x, y| x.first <=> y.first }

        wait_time * bus
      end

      def part2
        departures = parse_input[1].split(',').map.with_index do |bus, index|
          next if bus == 'x'

          [index, bus.to_i]
        end.compact

        prod = departures.reduce(1) { |p, x| p * x[1] }
        identities = departures.map do |departure|
          # solve s * bus + t * prod/bus = 1
          # and use t * (- index)
          a = departure[1]
          b = prod / departure[1]
          t = 0
          v = 1

          while b > 0
            q = a / b
            a, b = b, a % b
            t, v = v, t - q * v
          end

          - t * departure[0] * prod / departure[1]
        end

        identities.sum % prod
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          939
          7,13,x,x,59,x,31,19
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 13
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D13.new(test: false)
  today.run
end
