require_relative '../solution'

module AoC
  module Y2023
    class D19 < Solution

      Part = Struct.new(:x, :m, :a, :s)
      Workflow = Struct.new(:rules, :default)
      Rule = Struct.new(:var, :range, :workflow, :exclusion_range)

      def part1
        parts = get_input

        accepted = parts.filter do |part|
          apply_workflow('in', part)
        end

        accepted.sum do |part|
          part.x + part.m + part.a + part.s
        end
      end

      def apply_workflow(workflow, part)
        workflow = @workflows[workflow]
        applicable_rule = workflow.rules.find do |rule|
          rule.range.cover? part.public_send(rule.var)
        end

        next_workflow = applicable_rule&.workflow || workflow.default

        case next_workflow
        when 'A'
          true
        when 'R'
          false
        else
          apply_workflow(next_workflow, part)
        end
      end

      def part2
        count_accepted_parts('in', Part.new(RangeGroup.new(1..4000), RangeGroup.new(1..4000), RangeGroup.new(1..4000), RangeGroup.new(1..4000)))
      end

      def count_accepted_parts(workflow, parts)
        if workflow == 'A'
          return parts.map(&:size).inject(:*)
        elsif workflow == 'R'
          return 0
        end

        workflow = @workflows[workflow]
        rest_parts = parts
        matching_count = workflow.rules.sum do |rule|
          matching = parts.dup
          case rule.var
          when :x
            matching.x = matching.x.intersection rule.range
            rest_parts.x = rest_parts.x.intersection rule.exclusion_range
          when :m
            matching.m = matching.m.intersection rule.range
            rest_parts.m = rest_parts.m.intersection rule.exclusion_range
          when :a
            matching.a = matching.a.intersection rule.range
            rest_parts.a = rest_parts.a.intersection rule.exclusion_range
          when :s
            matching.s = matching.s.intersection rule.range
            rest_parts.s = rest_parts.s.intersection rule.exclusion_range
          end

          count_accepted_parts(rule.workflow, matching)
        end

        matching_count + count_accepted_parts(workflow.default, rest_parts)
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        workflows, parts = super.split("\n\n")
        @workflows = workflows.split("\n").to_h do |line|
          name, rules = line.match(/^(\w+)\{(.+?)\}$/).captures
          rule_parts = rules.split(',')
          default = rule_parts.pop
          rules = rule_parts.map do |rule|
            var, comp, val, wf = rule.match(/^([xmas])([<>])(\d+):(\w+)$/).captures
            if comp == '<'
              range = (1..val.to_i - 1)
              exclusion_range = (val.to_i..4000)
            else
              range = (val.to_i + 1..4000)
              exclusion_range = (1..val.to_i)
            end
            Rule.new(var.to_sym, range, wf, exclusion_range)
          end
          [name, Workflow.new(rules, default)]
        end
        parts.split("\n").map { |p| Part.new(*p.integers) }
      end

      def get_test_input(_number)
        <<~TEST
          px{a<2006:qkq,m>2090:A,rfg}
          pv{a>1716:R,A}
          lnx{m>1548:A,A}
          rfg{s<537:gd,x>2440:R,A}
          qs{s>3448:A,lnx}
          qkq{x<1416:A,crn}
          crn{x>2662:A,R}
          in{s<1351:px,qqz}
          qqz{s>2770:qs,m<1801:hdj,R}
          gd{a>3333:R,R}
          hdj{m>838:A,pv}

          {x=787,m=2655,a=1222,s=2876}
          {x=1679,m=44,a=2067,s=496}
          {x=2036,m=264,a=79,s=2244}
          {x=2461,m=1339,a=466,s=291}
          {x=2127,m=1623,a=2188,s=1013}
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 19
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D19.new(test: false)
  today.run
end
