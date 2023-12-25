require_relative '../solution'

module AoC
  module Y2023
    class D05 < Solution

      def part1
        ids, rules = parse_input
        ids = RangeGroup.new(*ids.map { |x| x..x })

        rules.each do |rule|
          ids = apply_map(rule, ids)
        end

        ids.min
      end

      def part2
        ids, rules = parse_input
        ids = RangeGroup.new(*ids.each_slice(2).map { |x, y| x .. x + y - 1 })

        rules.each do |rule|
          ids = apply_map(rule, ids)
        end

        ids.min
      end

      def apply_map(rules, input)
        new_ranges = []
        rules.each do |rule|
          matching_ids = input.intersection(rule[1])
          new_matching_ids = matching_ids.ranges.map do |range|
            range.first + rule[0] .. range.last + rule[0]
          end
          new_ranges += new_matching_ids
        end
        RangeGroup.new(*new_ranges)
      end

      private

      memoize def parse_input
        seeds, *rules = get_input.split("\n\n")
        seeds = seeds.split(": ")[1].split(' ').map(&:to_i)
        max_value = seeds.sum
        rules = rules.map do |rule|
          ruleparts = rule.split("\n")[1..]
          null_range = RangeGroup.new(0..max_value)
          ruleparts = ruleparts.map do |rulepart|
            dest, source, len = rulepart.split(' ').map(&:to_i)
            null_range.intersection!([0..source - 1, source + len..max_value])
            [dest - source, source .. source + len - 1]
          end
          ruleparts << [0, null_range]
          ruleparts
        end
        [seeds, rules]
      end

      def get_test_input(number)
        <<~TEST
          seeds: 79 14 55 13

          seed-to-soil map:
          50 98 2
          52 50 48

          soil-to-fertilizer map:
          0 15 37
          37 52 2
          39 0 15

          fertilizer-to-water map:
          49 53 8
          0 11 42
          42 0 7
          57 7 4

          water-to-light map:
          88 18 7
          18 25 70

          light-to-temperature map:
          45 77 23
          81 45 19
          68 64 13

          temperature-to-humidity map:
          0 69 1
          1 0 69

          humidity-to-location map:
          60 56 37
          56 93 4
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 5
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D05.new(test: false)
  today.run
end
