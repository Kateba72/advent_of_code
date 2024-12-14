require_relative '../solution'

# https://adventofcode.com/2020/day/23
module AoC
  module Y2020
    class D23 < Solution

      Cup = Struct.new(:label, :next, :previous)

      def part1
        current, cups = build_cups

        100.times do
          current = do_crab(current, cups)
        end

        concat_cups(cups).join
      end

      def part2
        current, cups = build_cups(part2: true)

        10_000_000.times do
          current = do_crab(current, cups)
        end

        one = cups[1]
        one.next.label * one.next.next.label
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.strip.chars.map(&:to_i)
      end

      def build_cups(part2: false)
        cup_order = parse_input
        cups = cup_order.to_h { [_1, Cup.new(_1, nil, nil)] }
        cup_order[1..].zip(cup_order[...-1]).each do |n, p|
          connect(cups[p], cups[n])
        end
        last_cup = cups[cup_order.last]
        if part2
          (10..1_000_000).each do |i|
            cup = cups[i] = Cup.new(i, nil, last_cup)
            last_cup.next = cup
            last_cup = cup
          end
        end
        first_cup = cups[cup_order.first]
        connect(last_cup, first_cup)

        [first_cup, cups]
      end

      def connect(first, second)
        first.next = second
        second.previous = first
      end

      def do_crab(current, cups)
        to_remove = [current.next]
        2.times do
          to_remove << to_remove.last.next
        end
        removed_labels = to_remove.map(&:label)
        connect(current, to_remove.last.next)

        destination_label = (current.label - 2) % cups.size + 1
        destination_label = (destination_label - 2) % cups.size + 1 while removed_labels.include? destination_label
        destination = cups[destination_label]
        after_destination = destination.next
        connect(destination, to_remove.first)
        connect(to_remove.last, after_destination)

        current.next
      end

      def concat_cups(cups)
        one = cups[1]
        current = one.next
        arr = []
        while current != one
          arr << current.label
          current = current.next
        end
        arr
      end

      def get_test_input(_number)
        <<~TEST
          389125467
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 23
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D23.new(test: test)
  today.run
end
