require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day25
  include Memoized

  def part1
    input = get_input
    sum = input.sum do |line|
      to_decimal(line)
    end
    to_snafu(sum)
  end

  def to_decimal(snafu)
    sum = 0
    snafu_chars = { '2' => 2, '1' => 1, '0' => 0, '-' => -1, '=' => -2 }
    snafu.chars.reverse.each_with_index do |char, index|
      sum += snafu_chars[char] * 5**index
    end
    sum
  end

  def to_snafu(decimal)
    carry_over = 0
    snafu_digits = { 2 => '2', 1 => '1', 0 => '0', -1 => '-', -2 => '=' }
    reverse_snafu = decimal.to_s(5).chars.reverse.map do |char|
      digit = char.to_i + carry_over
      carry_over = 0
      if digit >= 3
        digit -= 5
        carry_over = 1
      end
      snafu_digits[digit]
    end
    reverse_snafu.append '1' if carry_over == 1
    reverse_snafu.reverse.join
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
      get_aoc_input(2022, 25)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1 = [nil, nil]
  puts 'Day 25'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day25.new }
    benchmark.report('Input parsing') { today.send(:get_input) }
    benchmark.report('Part 1') { part1 = today.part1 }
  end
  puts
  puts 'Part 1:'
  puts part1
end
