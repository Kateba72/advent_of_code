require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day21
  include Memoized

  def part1
    @monkeys = get_input.deep_dup
    calculate_monkey('root')
  end

  def part2
    # The result seems to be linear in humn, so no need for anything fancy
    @monkeys = get_input.deep_dup
    @monkeys['root'][0] = :-
    @monkeys['humn'] = [:number, 0+1i]
    result = calculate_monkey('root')

    (result.real / result.imaginary).to_i.abs
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
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

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 21)
    end.split("\n").map do |line|
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
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 21'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day21.new }
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
