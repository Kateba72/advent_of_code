require_relative '../aoc_defaults'
# require 'matrix'

class Day5
  include Memoized

  def part1
    _stacks, instructions = get_input
    stacks = _stacks.deep_dup
    instructions.map do |instruction|
      stacks = apply_instruction_9000 stacks, instruction
    end
    stacks.map(&:last).join
  end

  def part2
    _stacks, instructions = get_input
    stacks = _stacks.deep_dup
    instructions.map do |instruction|
      stacks = apply_instruction_9001 stacks, instruction
    end
    stacks.map(&:last).join
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def apply_instruction_9000(stacks, instruction)
    instruction[0].times do
      item = stacks[instruction[1]].pop
      stacks[instruction[2]].append item
    end
    stacks
  end

  def apply_instruction_9001(stacks, instruction)
    item = stacks[instruction[1]].pop instruction[0]
    stacks[instruction[2]].append(*item)
    stacks
  end

  memoize def get_input
    input = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 5)
    end
    stack_text, instructions = input.split("\n\n")
    stack_lines = stack_text.split("\n").reverse
    stacks_count = stack_lines.first.scan(/\d+/).last.to_i
    stacks = (0...stacks_count).map do |i|
      stack = stack_lines[1..].map { _1[i * 4 + 1] }.compact
      stack.delete ' '
      stack
    end
    instructions = instructions.split("\n").map do |line|
      m = line.match(/^move (\d+) from (\d+) to (\d+)$/)
      [m[1].to_i, m[2].to_i - 1, m[3].to_i - 1]
    end
    [stacks, instructions]
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today = Day5.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end
