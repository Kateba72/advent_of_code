require_relative '../solution'

module AoC
  module Y2023
    class D06 < Solution

      def part1
        times, distances = parse_input
        times = times.split[1..].map(&:to_i)
        distances = distances.split[1..].map(&:to_i)

        times.zip(distances).map do |time, distance|
          (0..time).count do |t|
            t * (time - t) > distance
          end
        end.inject(:*)
      end

      def part2
        times, distances = parse_input
        time = times.split(':')[1].gsub(' ', '').to_i
        distance = distances.split(':')[1].gsub(' ', '').to_i

        start_time = (0..(time / 2)).bsearch do |t|
          t * (time - t) > distance
        end
        end_time = time - start_time

        (start_time..end_time).size
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          Time:      7  15   30
          Distance:  9  40  200
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 6
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D06.new(test: false)
  today.run
end
