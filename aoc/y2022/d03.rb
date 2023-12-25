require_relative '../solution'

module AoC
  module Y2022
    class D03 < Solution

      def part1
        input = parse_input
        input.sum do |line|
          priority(shared_item(line))
        end
      end

      def part2
        input = parse_input
        input.in_groups_of(3).sum do |group|
          priority(badge(group))
        end
      end

      private

      def shared_item(line)
        first_compartment = line[...line.size/2].chars.to_set
        second_compartment = line[line.size/2..].chars.to_set
        (first_compartment & second_compartment).first
      end

      def badge(group)
        group.map do |line|
          line.chars.to_set
        end.reduce(&:intersection).first
      end

      def priority(char)
        char.ord >= 97 ? char.ord - 96 : char.ord - 64 + 26
      end

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(number)
        <<~TEST
          vJrwpWtwJgWrhcsFMMfFFhFp
          jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
          PmmdzqPrVvPwwTWBwg
          wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
          ttgJtRGJQctTZtZT
          CrZsJsPPZsGzwwsLwLmpwMDw
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 3
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D03.new(test: false)
  today.run
end
