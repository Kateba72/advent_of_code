require_relative '../solution'

# https://adventofcode.com/2024/day/24
module AoC
  module Y2024
    class D24 < Solution

      def part1
        input = parse_input

        z = input.keys.filter_map { Regexp.last_match[1].to_i if _1.match(/^z0*(\d+)$/) }.max
        out = 0
        while z >= 0
          out <<= 1
          out += get_value(input, "z#{z.to_s.rjust(2, '0')}")
          z -= 1
        end

        out
      end

      def part2
        input = parse_input

        ands = []
        xors = []

        swaps = [%w[z06 ksv], %w[kbs nbd], %w[z20 tqq], %w[z39 ckb]] # manually populated
        return swaps.flatten.sort.join(',') if swaps.size == 4

        swaps.each do |key1, key2|
          input[key1], input[key2] = input[key2], input[key1]
        end

        max_z = input.keys.filter_map { Regexp.last_match[1].to_i if _1.match(/^z0*(\d+)$/) }.max

        input.each do |key, wire|
          next unless wire.is_a?(Wire)

          wire.in1, wire.in2 = wire.in2, wire.in1 if wire.in1 > wire.in2

          next unless (m = wire.in1.match(/^x0*(\d+)$/)) && wire.in1.gsub('x', 'y') == wire.in2

          idx = m[1].to_i
          if wire.op == 'AND'
            ands[idx] = key
          elsif wire.op == 'XOR'
            xors[idx] = key
          end
        end

        rules_by_input = input.filter_map do |key, wire|
          next unless wire.is_a? Wire

          op = wire.op == 'OR' ? 'XOR' : wire.op # Every or can also be replaced by xor

          [
            [[wire.in1, wire.in2, op], key],
            [[wire.in2, wire.in1, op], key],
          ]
        end.flatten(1).to_h

        puts "z00 and #{xors[0]} are swapped" unless xors[0] == 'z00'

        result = []
        carry_and = []
        carry = []

        carry[0] = ands[0]

        (1...max_z).each do |idx|
          z = "z#{idx.to_s.rjust(2, '0')}"
          result[idx] = rules_by_input[[carry[idx - 1], xors[idx], 'XOR']]
          raise "1 Could not find carry[#{idx - 1}] XOR xor[#{idx}]" unless result[idx]

          puts "#{z} and #{result[idx]} are swapped" unless result[idx] == z

          carry_and[idx] = rules_by_input[[carry[idx - 1], xors[idx], 'AND']]
          raise "2 Could not find carry[#{idx - 1}] AND xor[#{idx}]" unless carry_and[idx]

          carry[idx] = rules_by_input[[ands[idx], carry_and[idx], 'XOR']]
          raise "3 Could not find and[#{idx}] (X)OR carry_and[#{idx}]" unless carry[idx]
        end
      rescue RuntimeError => e
        puts e.message
        binding.break # rubocop:disable Lint/Debugger
      end

      def get_value(rules, key)
        rule = rules[key]
        return rule unless rule.is_a?(Wire)

        rules[key] = case rule.op
        when 'AND'
          get_value(rules, rule.in1) & get_value(rules, rule.in2)
        when 'OR'
          get_value(rules, rule.in1) | get_value(rules, rule.in2)
        when 'XOR'
          get_value(rules, rule.in1) ^ get_value(rules, rule.in2)
        else
          raise "Parse error: Invalid rule #{rule}"
        end
      end

      def get_rule(rules, key)
        rule = rules[key]
        return key unless rule.is_a?(Wire)

        in1 = get_rule(rules, rule.in1)
        in2 = get_rule(rules, rule.in2)

        "(#{in1} #{rule.op} #{in2})"
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      Wire = Struct.new(:in1, :op, :in2)

      def parse_input
        initialized, wires = get_input.split("\n\n")
        rules = initialized.split("\n").to_h do |rule|
          gate, value = rule.split(': ')
          [gate, value.to_i]
        end
        wires.split("\n").each do |wire|
          rule, out = wire.split(' -> ')
          rules[out] = Wire.new(*rule.split)
        end

        rules
      end

      def get_test_input(_number)
        <<~TEST
          x00: 1
          x01: 0
          x02: 1
          x03: 1
          x04: 0
          y00: 1
          y01: 1
          y02: 1
          y03: 1
          y04: 1

          ntg XOR fgs -> mjb
          y02 OR x01 -> tnw
          kwq OR kpj -> z05
          x00 OR x03 -> fst
          tgd XOR rvg -> z01
          vdt OR tnw -> bfw
          bfw AND frj -> z10
          ffh OR nrd -> bqk
          y00 AND y03 -> djm
          y03 OR y00 -> psh
          bqk OR frj -> z08
          tnw OR fst -> frj
          gnj AND tgd -> z11
          bfw XOR mjb -> z00
          x03 OR x00 -> vdt
          gnj AND wpb -> z02
          x04 AND y00 -> kjc
          djm OR pbm -> qhw
          nrd AND vdt -> hwm
          kjc AND fst -> rvg
          y04 OR y02 -> fgs
          y01 AND x02 -> pbm
          ntg OR kjc -> kwq
          psh XOR fgs -> tgd
          qhw XOR tgd -> z09
          pbm OR djm -> kpj
          x03 XOR y03 -> ffh
          x00 XOR y04 -> ntg
          bfw OR bqk -> z06
          nrd XOR fgs -> wpb
          frj XOR qhw -> z04
          bqk OR frj -> z07
          y03 OR x01 -> nrd
          hwm AND bqk -> z03
          tgd XOR rvg -> z12
          tnw OR pbm -> gnj
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 24
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D24.new(test: test)
  today.run
end
