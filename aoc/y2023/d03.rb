require_relative '../solution'

module AoC
  module Y2023
    class D03 < Solution

      def part1
        lines = parse_input.split("\n")
        symbols = lines.map do |line|
          line.enum_for(:scan, /[^.\w]/).map do
            Regexp.last_match.offset(0).first
          end
        end
        numbers = lines.map.with_index do |line, index|
          line.enum_for(:scan, /\d+/).sum do
            offset_range = (Regexp.last_match.offset(0).first - 1)..(Regexp.last_match.offset(0).last)
            if (index > 0 && symbols[index - 1].any? { |x| offset_range.include? x }) ||
                (symbols[index].any? { |x| offset_range.include? x }) ||
                (index < lines.size - 1 && symbols[index + 1].any? { |x| offset_range.include? x })
              Regexp.last_match.to_s.to_i
            else
              0
            end
          end
        end
        numbers.sum
      end

      def part2
        lines = parse_input.split("\n")
        gear_candidates = lines.map do |line|
          line.enum_for(:scan, /\*/).map do
            Regexp.last_match.offset(0).first
          end
        end
        gears = {}
        lines.map.with_index do |line, index|
          line.enum_for(:scan, /\d+/).each do
            offset_range = (Regexp.last_match.offset(0).first - 1)..(Regexp.last_match.offset(0).last)
            value = Regexp.last_match.to_s.to_i
            if index > 0
              gear_candidates[index - 1].each do |x|
                next unless offset_range.include? x

                gears[[index - 1, x]] ||= []
                gears[[index - 1, x]] << value
              end
            end
            if index < lines.size - 1
              gear_candidates[index + 1].each do |x|
                next unless offset_range.include? x

                gears[[index + 1, x]] ||= []
                gears[[index + 1, x]] << value
              end
            end
            gear_candidates[index].each do |x|
              next unless offset_range.include? x

              gears[[index, x]] ||= []
              gears[[index, x]] << value
            end
          end
        end

        gears.sum do |_pos, gear|
          next 0 unless gear.size > 1

          gear.inject(:*)
        end
      end

      private

      memoize def parse_input
        get_input
      end

      def get_test_input(_number)
        <<~TEST
          467..114..
          ...*......
          ..35..633.
          ......#...
          617*......
          .....+.58.
          ..592.....
          ......755.
          ...$.*....
          .664.598..
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D03.new(test: false)
  today.run
end
