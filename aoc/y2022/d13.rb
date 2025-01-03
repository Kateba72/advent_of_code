require_relative '../solution'

module AoC
  module Y2022
    class D13 < Solution

      def part1
        pairs = parse_input

        indexes_sum = 0
        pairs.each_with_index do |pair, index|
          indexes_sum += index + 1 if pair[0] <= pair[1]
        end

        indexes_sum
      end

      def part2
        packets = parse_input.flatten

        divider_2 = Packet.new([[2]])
        divider_6 = Packet.new([[6]])

        packets << divider_2
        packets << divider_6

        packets.sort!

        (packets.index(divider_2) + 1) * (packets.index(divider_6) + 1)
      end

      private

      memoize def parse_input
        get_input.split("\n\n").map do |pair|
          pair.split("\n").map { |packet| Packet.new(JSON.parse(packet)) }
        end
      end

      def get_test_input(_number)
        <<~TEST
          [1,1,3,1,1]
          [1,1,5,1,1]

          [[1],[2,3,4]]
          [[1],4]

          [9]
          [[8,7,6]]

          [[4,4],4,4]
          [[4,4],4,4,4]

          [7,7,7,7]
          [7,7,7]

          []
          [3]

          [[[]]]
          [[]]

          [1,[2,[3,[4,[5,6,7]]]],8,9]
          [1,[2,[3,[4,[5,6,0]]]],8,9]
        TEST
      end

      class Packet
        include Comparable

        attr_reader :value

        def initialize(value)
          @value = value
        end

        def <=>(other)
          compare(value, other.value)
        end

        def to_s
          value.to_s.gsub(', nil', '')
        end

        private

        def compare(left, right)
          if left.is_a? Integer
            if right.is_a? Integer
              left <=> right
            else
              compare([left], right)
            end
          elsif right.is_a? Integer
            compare(left, [right])
          else
            left[right.size - 1] ||= nil unless right == []
            ret = left.zip(right).each do |l, r|
              break 0 if l.nil? && r.nil?
              break -1 if l.nil?
              break 1 if r.nil?

              these = compare(l, r)
              break these unless these == 0
            end
            ret.is_a?(Integer) ? ret : 0
          end
        end
      end

      AOC_YEAR = 2022
      AOC_DAY = 13
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D13.new(test: false)
  today.run
end
