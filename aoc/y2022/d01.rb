require_relative '../solution'

module AoC
  module Y2022
    class D01 < Solution

      def part1
        elves.max
      end

      def part2
        elves.sort.last(3).sum
      end

      memoize def elves
        get_input.split("\n\n").map do |elf|
          elf.split("\n").map(&:to_i).sum
        end
      end

      private

      def get_test_input(number)
        <<~TEST
          1000
          2000
          3000

          4000

          5000
          6000

          7000
          8000
          9000

          10000
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 1
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D01.new(test: false)
  today.run
end
