require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day202018
  include Memoized

  def part1
    input = get_input

    input.sum do |calculation|
      evaluate_expression(calculation, :evaluate_ltr)
    end
  end

  def part2
    input = get_input

    input.sum do |calculation|
      evaluate_expression(calculation, :evaluate_sadmep)
    end
  end

  def evaluate_expression(calculation, evaluation_method)
    calculation = calculation.dup
    while calculation.include? '('
      calculation.gsub!(/\(([0-9 +*]+)\)/) do |subexpr|
        public_send(evaluation_method, Regexp.last_match[1])
      end
    end
    public_send(evaluation_method, calculation)
  end

  def evaluate_ltr(calculation)
    parts = calculation.split(' ')
    value = parts.shift.to_i
    parts.each_slice(2) do |expr, number|
      case expr
      when '+'
        value += number.to_i
      when '*'
        value *= number.to_i
      else
        raise "unknown expression #{expr}"
      end
    end
    value
  end

  def evaluate_sadmep(calculation)
    while calculation.include? '+'
      calculation.gsub!(/(\d+) \+ (\d+)/) do
        Regexp.last_match[1].to_i + Regexp.last_match[2].to_i
      end
    end
    while calculation.include? '*'
      calculation.gsub!(/(\d+) \* (\d+)/) do
        Regexp.last_match[1].to_i * Regexp.last_match[2].to_i
      end
    end
    calculation.to_i
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2020, 18)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
5 + (8 * 3 + 9 + 3 * 4 * 3)
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 18'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day202018.new }
    benchmark.report('Input parsing') { today.send(:get_input) }
    benchmark.report('Part 1') { part1 = today.part1 }
    benchmark.report('Part 2') { part2 = today.part2 }
  end
  puts
  puts 'Part 1:'
  puts part1
  puts
  puts 'Part 2:'
  puts part2
end
