require_relative '../solution'

module AoC
  module Y2021
    class D08 < Solution

      def part1
        lines = parse_input

        lines.sum do |line|
          line[1].count do |x|
            x.size.in? [2, 3, 4, 7]
          end
        end
      end

      def part2
        lines = parse_input

        lines.sum do |line|
          decryption = decrypt(line[0])
          line[1].map { decryption.fetch(_1.chars.sort) }.join.to_i
        end
      end

      def decrypt(line)
        decryption = {}
        one = nil
        four = nil
        line.each do |part|
          part = part.chars.sort
          case part.size
          when 2
            decryption[part] = '1'
            one = part.to_set
          when 3
            decryption[part] = '7'
          when 4
            decryption[part] = '4'
            four = part.to_set
          when 7
            decryption[part] = '8'
          end
        end
        line.each do |part|
          part = part.chars.sort
          next if decryption.include? part
          chars = part.to_set
          intersect_one = (chars & one).size
          intersect_four = (chars & four).size
          case [part.size, intersect_one, intersect_four]
          when [5, 2, 3]
            decryption[part] = '3'
          when [5, 1, 2]
            decryption[part] = '2'
          when [5, 1, 3]
            decryption[part] = '5'
          when [6, 2, 3]
            decryption[part] = '0'
          when [6, 2, 4]
            decryption[part] = '9'
          when [6, 1, 3]
            decryption[part] = '6'
          else
            p part.size, intersect_one, intersect_four
            raise
          end
        end

        decryption
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          line.split(" | ").map(&:split)
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 8
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D08.new(test: false)
  today.run
end
