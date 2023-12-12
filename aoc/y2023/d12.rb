# require 'matrix'
require_relative '../base_class'

module AoC
  module Y2023
    class D12 < BaseClass

      def part1
        input = get_input
        input.sum do |line|
          matches(*line)
        end
      end

      memoize def matches(springs, arr)
        play = [springs.size - arr.sum - arr.size + 1, springs.index('#') || springs.size].min
        (0..play).sum do |offset|
          next 0 unless is_group(springs[offset..offset + arr[0]], arr[0])
          if arr.size == 1
            springs[offset+arr[0]+1..]&.index('#') ? 0 : 1
          else
            matches(springs[offset + arr[0] + 1..], arr[1..])
          end
        end
      end

      memoize def is_group(springs, size)
        (springs[-1] == '.' || springs[-1] == '?' || springs.size == size) && springs[...size].chars.all? { |c| c == '#' || c == '?' }
      end

      def part2
        input = get_input
        input.sum do |line|
          springs, arr = line
          u_spr = ([springs] * 5).join('?')
          matches(u_spr, arr * 5)
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.split("\n").map do |line|
          springs, ints = line.split(' ')
          [springs, ints.integers]
        end
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 12
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D12.new(test: false)
  today.run
end
