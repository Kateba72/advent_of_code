require_relative '../solution'

module AoC
  module Y💙year💙
    class D💙day💙 < Solution

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 💙year💙
      AOC_DAY = 💙day_nlz💙
    end
  end
end

if __FILE__ == $0
  today = AoC::Y💙year💙::D💙day💙.new(test: false)
  today.run
end
