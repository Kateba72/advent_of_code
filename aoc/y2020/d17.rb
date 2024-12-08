require_relative '../solution'

module AoC
  module Y2020
    class D17 < Solution

      def part1
        input = parse_input

        active = Set.new
        input.split("\n").each_with_index do |line, x|
          line.chars.each_with_index do |char, y|
            next if char == '.'

            active << [x, y, 0]
          end
        end

        borders = [0..input.split("\n").size - 1, 0..input.index("\n") - 1, 0..0]

        6.times do
          active, borders = do_3d_conway(active, borders)
        end

        active.size
      end

      def part2
        input = parse_input

        active = Set.new
        input.split("\n").each_with_index do |line, x|
          line.chars.each_with_index do |char, y|
            next if char == '.'

            active << [x, y, 0, 0]
          end
        end

        borders = [(0..input.split("\n").size - 1).to_a, (0..input.index("\n") - 1).to_a, [0], [0]]

        6.times do
          active, borders = do_4d_conway(active, borders)
        end

        active.size
      end

      def do_3d_conway(old_active, old_borders)
        new_active = Set.new
        new_borders = old_borders.map do |old_border|
          (old_border.first - 1)..(old_border.last + 1)
        end

        new_borders[0].each do |x|
          new_borders[1].each do |y|
            new_borders[2].each do |z|
              surrounding_count = (([old_borders[0].first, x - 1].max)..([old_borders[0].last, x + 1].min)).sum do |other_x|
                (([old_borders[1].first, y - 1].max)..([old_borders[1].last, y + 1].min)).sum do |other_y|
                  (([old_borders[2].first, z - 1].max)..([old_borders[2].last, z + 1].min)).count do |other_z|
                    old_active.include? [other_x, other_y, other_z]
                  end
                end
              end
              if old_active.include? [x, y, z]
                new_active << [x, y, z] if [3, 4].include?(surrounding_count)
              elsif surrounding_count == 3
                new_active << [x, y, z]
              end
            end
          end
        end

        [new_active, new_borders]
      end

      def do_4d_conway(old_active, old_borders)
        new_active = Set.new
        new_borders = old_borders.map do |old_border|
          ((old_border.first - 1)..(old_border.last + 1)).to_a
        end

        [nil].product(*new_borders).each do |_, x, y, z, w|
          surrounding_count = 0
          [nil].product(
            (([old_borders[0].first, x - 1].max)..([old_borders[0].last, x + 1].min)).to_a,
            (([old_borders[1].first, y - 1].max)..([old_borders[1].last, y + 1].min)).to_a,
            (([old_borders[2].first, z - 1].max)..([old_borders[2].last, z + 1].min)).to_a,
            (([old_borders[3].first, w - 1].max)..([old_borders[3].last, w + 1].min)).to_a,
          ).each do |_other, other_x, other_y, other_z, other_w|
            next unless old_active.include? [other_x, other_y, other_z, other_w]

            surrounding_count += 1
            break if surrounding_count > 4
          end

          if old_active.include? [x, y, z, w]
            new_active << [x, y, z, w] if [3, 4].include?(surrounding_count)
          elsif surrounding_count == 3
            new_active << [x, y, z, w]
          end
        end

        [new_active, new_borders]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input
      end

      def get_test_input(_number)
        <<~TEST
          .#.
          ..#
          ###
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 17
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D17.new(test: false)
  today.run
end
