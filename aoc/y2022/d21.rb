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
        @monkeys['humn'] = [:number, 0 + 1i]
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
        get_input.split("\n").to_h do |line|
          m = line.match(%r{^(\w+): ((\d+)|(\w+) ([+\-*/]) (\w+))$})
          if m[3]
            [m[1], [:number, m[3].to_i]]
          else
            [m[1], [m[5].to_sym, m[4], m[6]]]
          end
        end
      end

      def get_test_input(_number)
        <<~TEST
          root: pppw + sjmn
          dbpl: 5
          cczh: sllz + lgvd
          zczc: 2
          ptdq: humn - dvpt
          dvpt: 3
          lfqf: 4
          humn: 5
          ljgn: 2
          sjmn: drzm * dbpl
          sllz: 4
          pppw: cczh / lfqf
          lgvd: ljgn * ptdq
          drzm: hmdt - zczc
          hmdt: 32
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
