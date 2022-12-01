require_relative '../aoc_defaults'
# require 'matrix'

class Day16
  include Memoized

  def part1
    get_input => { other_tickets: }

    valid_values = calculate_valid_values
    other_tickets.flatten.filter { |value| !valid_values[value] }.sum
  end

  def part2
    get_input => { rules:, your_ticket:, other_tickets: }

    mapping_options = rules.keys.map do |key|
      [key, [true] * your_ticket.size]
    end.to_h

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
        mapping_options.keys.each do |other_rule_key|
          mapping_options[other_rule_key][index] = false
        end
      end

      break if mapping_options.blank?
    end

    map.keys.filter { |key| key.start_with? 'departure' }.map { |key| your_ticket[map[key]]}.inject 1, &:*
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def calculate_valid_values
    valid_values = []
    get_input[:rules].values.flatten.each do |rule|
      rule.each { |value| valid_values[value] = true }
    end
    valid_values
  end

  memoize def get_input
    input = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2020, 16)
    end

    rules, your_ticket, other_tickets = input.split("\n\n")
    rules = rules.split("\n").map do |rule|
      match_data = rule.match(/^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$/)
      [match_data[1], [(match_data[2].to_i)..(match_data[3].to_i), (match_data[4].to_i)..(match_data[5].to_i)]]
    end.to_h

    your_ticket = your_ticket.split("\n")[1].split(',').map(&:to_i)
    other_tickets = other_tickets.split("\n")[1..].map do |ticket|
      ticket.split(',').map(&:to_i)
    end
    { rules:, your_ticket:, other_tickets: }
  end

  def get_test_input(number)
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
end

if __FILE__ == $0
  today = Day16.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end
