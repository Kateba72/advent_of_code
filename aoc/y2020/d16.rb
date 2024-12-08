require_relative '../solution'

module AoC
  module Y2020
    class D16 < Solution

      def part1
        parse_input => { other_tickets: }

        valid_values = calculate_valid_values
        other_tickets.flatten.filter { |value| !valid_values[value] }.sum
      end

      def part2
        parse_input => { rules:, your_ticket:, other_tickets: }

        mapping_options = rules.keys.to_h do |key|
          [key, [true] * your_ticket.size]
        end

        valid_values = calculate_valid_values
        other_tickets.each do |ticket|
          next unless ticket.all? { |value| valid_values[value] }

          ticket.each_with_index do |value, index|
            rules.each do |rule_key, rule_values|
              mapping_options[rule_key][index] &&= rule_values[0].include?(value) || rule_values[1].include?(value)
            end
          end
        end

        map = {}
        (1..mapping_options.size).each do
          mapping_options.each do |rule_key, allowed_indexes|
            next if allowed_indexes.count { |value| value } > 1

            index = allowed_indexes.index(true)
            map[rule_key] = index
            mapping_options.delete rule_key
            mapping_options.each_key do |other_rule_key|
              mapping_options[other_rule_key][index] = false
            end
          end

          break if mapping_options.blank?
        end

        map.keys.filter { |key| key.start_with? 'departure' }.map { |key| your_ticket[map[key]] }.inject 1, &:*
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def calculate_valid_values
        valid_values = []
        parse_input[:rules].values.flatten.each do |rule|
          rule.each { |value| valid_values[value] = true }
        end
        valid_values
      end

      memoize def parse_input
        rules, your_ticket, other_tickets = get_input.split("\n\n")
        rules = rules.split("\n").to_h do |rule|
          match_data = rule.match(/^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$/)
          [match_data[1], [(match_data[2].to_i)..(match_data[3].to_i), (match_data[4].to_i)..(match_data[5].to_i)]]
        end

        your_ticket = your_ticket.split("\n")[1].split(',').map(&:to_i)
        other_tickets = other_tickets.split("\n")[1..].map do |ticket|
          ticket.split(',').map(&:to_i)
        end
        { rules:, your_ticket:, other_tickets: }
      end

      def get_test_input(_number)
        <<~TEST
          class: 1-3 or 5-7
          row: 6-11 or 33-44
          seat: 13-40 or 45-50

          your ticket:
          7,1,14

          nearby tickets:
          7,3,47
          40,4,50
          55,2,20
          38,6,12
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 16
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2020::D16.new(test: false)
  today.run
end
