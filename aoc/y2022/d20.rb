require_relative '../solution'

module AoC
  module Y2022
    class D20 < Solution

      def part1
        list = parse_input

        linked_list = generate_linked_list(list)
        mix_list(linked_list)
        coordinate_sum(linked_list)
      end

      def part2
        list = parse_input
        linked_list = generate_linked_list(list)

        linked_list.each do |entry|
          entry[:value] *= 811_589_153
        end
        10.times do
          mix_list(linked_list)
        end
        coordinate_sum(linked_list)
      end

      def coordinate_sum(linked_list)
        zero = linked_list.find { |entry| entry[:value] == 0 }
        thousand = zero
        1000.times { thousand = thousand[:next] }
        two_thousand = thousand
        1000.times { two_thousand = two_thousand[:next] }
        three_thousand = two_thousand
        1000.times { three_thousand = three_thousand[:next] }

        thousand[:value] + two_thousand[:value] + three_thousand[:value]
      end

      def mix_list(linked_list)
        size = linked_list.size
        linked_list.each do |entry|
          value = entry[:value] % (size - 1)
          next if value == 0

          if value >= size / 2
            value = size - 1 - value
            other_entry = entry
            value.times do
              other_entry = other_entry[:last]
            end
            before = other_entry[:last]
            after = other_entry
          else
            other_entry = entry
            value.times do
              other_entry = other_entry[:next]
            end
            before = other_entry
            after = other_entry[:next]
          end

          entry[:last][:next] = entry[:next]
          entry[:next][:last] = entry[:last]

          before[:next] = entry
          after[:last] = entry
          entry[:last] = before
          entry[:next] = after
        end
      end

      def linked_list_to_a(list)
        entry = list.first
        [list.first[:value]] + (1...list.size).map do
          entry = entry[:next]
          entry[:value]
        end
      end

      private

      def generate_linked_list(list)
        last = nil
        linked_list = list.map do |value|
          this_entry = {
            value:,
            last:,
            next: nil,
          }
          last[:next] = this_entry if last
          last = this_entry
          this_entry
        end
        last[:next] = linked_list.first
        linked_list.first[:last] = last
        linked_list
      end

      memoize def parse_input
        get_input.split("\n").map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          1
          2
          -3
          3
          -2
          0
          4
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 20
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D20.new(test: false)
  today.run
end
