require_relative '../solution'

module AoC
  module Y2022
    class D21 < Solution

      def part1
        @monkeys = parse_input.deep_dup
        calculate_monkey('root')
      end

      def part2
        # The result seems to be linear in humn, so no need for anything fancy
        @monkeys = parse_input.deep_dup
        @monkeys['root'][0] = :-
        @monkeys['humn'] = [:number, 0+1i]
        result = calculate_monkey('root')

        (result.real / result.imaginary).to_i.abs
      end

      private

      def calculate_monkey(name)
        monkey = @monkeys[name]
        result = case monkey[0]
        when :number
          return monkey[1]
        when :+
          calculate_monkey(monkey[1]) + calculate_monkey(monkey[2])
        when :-
          calculate_monkey(monkey[1]) - calculate_monkey(monkey[2])
        when :*
          calculate_monkey(monkey[1]) * calculate_monkey(monkey[2])
        when :/
          calculate_monkey(monkey[1]) / calculate_monkey(monkey[2])
        end
        @monkeys[name] = [:number, result]
        result
      end

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^(\w+): ((\d+)|(\w+) ([+\-*\/]) (\w+))$/)
          if m[3]
            [m[1], [:number, m[3].to_i]]
          else
            [m[1], [m[5].to_sym, m[4], m[6]]]
          end
        end.to_h
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 21
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D21.new(test: false)
  today.run
end
