# require 'matrix'
require_relative '../base_class'

module AoC
  module Y💙year💙
    class D💙day💙 < BaseClass
      include Memoized

      def part1
        input = get_input

      end

      def part2
        input = get_input
        'Not Implemented'
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def get_input
        super.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 💙year💙
      AOC_DAY = 💙day💙
    end
  end
end

if __FILE__ == $0
  today = AoC::Y💙year💙::D💙day💙.new(test: false)
  today.run
end
