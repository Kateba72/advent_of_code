require_relative '../solution'

module AoC
  module Y2021
    class D18 < Solution

      def part1
        input = parse_input

        magn = input[1..].inject(SnailfishNumber.new(input[0])) do |sum, x|
          sum + SnailfishNumber.new(x)
        end.magnitude
        magn
      end

      def part2
        input = parse_input
        max = input.product(input).map do |x, y|
          next 0 if x == y
          (SnailfishNumber.new(x) + SnailfishNumber.new(y)).magnitude
        end.max
        max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end
      
      class SnailfishNumber
        attr_accessor :number, :first, :last, :depth

        def initialize(arr, depth=0)
          arr = eval(arr) if String === arr
          arr = arr.number if SnailfishNumber === arr && arr.number?
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
            "[#{self.first.to_s},#{self.last.to_s}]"
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
          else
            if explosion = first.explode
              self.last.add_to_first(explosion[1]) if explosion[1] > 0
              [explosion[0], 0]
            elsif explosion = last.explode
              self.first.add_to_last(explosion[0]) if explosion[0] > 0
              [0, explosion[1]]
            else
              nil
            end
          end
        end

        def split
          if pair?
            first.split || last.split
          else
            if number >= 10
              self.first = SnailfishNumber.new(number / 2, depth + 1)
              self.last = SnailfishNumber.new((number + 1) / 2, depth + 1)
              self.number = nil
              true
            end
          end
        end

        def add_to_first(value)
          if number?
            self.number += value
          else
            self.first.add_to_first(value)
          end
        end

        def add_to_last(value)
          if number?
            self.number += value
          else
            self.last.add_to_last(value)
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
