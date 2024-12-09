require_relative '../solution'

module AoC
  module Y2021
    class D18 < Solution

      def part1
        input = parse_input

        input[1..].inject(SnailfishNumber.new(input[0])) do |sum, x|
          sum + SnailfishNumber.new(x)
        end.magnitude
      end

      def part2
        input = parse_input
        input.product(input).map do |x, y|
          next 0 if x == y

          (SnailfishNumber.new(x) + SnailfishNumber.new(y)).magnitude
        end.max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          [1,2]
          [[1,2],3]
          [9,[8,7]]
          [[1,9],[8,5]]
          [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
          [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
          [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
        TEST
      end

      class SnailfishNumber
        attr_accessor :number, :first, :last, :depth

        def initialize(arr, depth = 0)
          arr = eval(arr) if arr.is_a?(String)
          arr = arr.number if arr.is_a?(SnailfishNumber) && arr.number?
          case arr
          when Integer
            @number = arr
            @first = nil
            @last = nil
          else
            @number = nil
            @first = SnailfishNumber.new(arr.first, depth + 1)
            @last = SnailfishNumber.new(arr.last, depth + 1)
          end
          @depth = depth
        end

        def +(other)
          SnailfishNumber.new([self, other]).reduce
        end

        def magnitude
          if pair?
            3 * first.magnitude + 2 * last.magnitude
          else
            number
          end
        end

        def to_s
          if number?
            number.to_s
          else
            "[#{first},#{last}]"
          end
        end

        def number?
          @number.present?
        end

        def pair?
          @first.present?
        end

        def reduce
          loop do
            did_something = explode || split
            break unless did_something
          end
          self
        end

        def explode
          return unless pair?

          if depth >= 4
            ret = [first.number, last.number]
            self.number = 0
            self.first = nil
            self.last = nil
            ret
          elsif (explosion = first.explode)
            last.add_to_first(explosion[1]) if explosion[1] > 0
            [explosion[0], 0]
          elsif (explosion = last.explode)
            first.add_to_last(explosion[0]) if explosion[0] > 0
            [0, explosion[1]]
          end
        end

        def split
          if pair?
            first.split || last.split
          elsif number >= 10
            self.first = SnailfishNumber.new(number / 2, depth + 1)
            self.last = SnailfishNumber.new((number + 1) / 2, depth + 1)
            self.number = nil
            true
          end
        end

        def add_to_first(value)
          if number?
            self.number += value
          else
            first.add_to_first(value)
          end
        end

        def add_to_last(value)
          if number?
            self.number += value
          else
            last.add_to_last(value)
          end
        end
      end

      AOC_YEAR = 2021
      AOC_DAY = 18
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D18.new(test: false)
  today.run
end
