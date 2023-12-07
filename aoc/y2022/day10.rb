require_relative '../aoc_defaults'
# require 'matrix'

class Day10
  include Memoized

  def calculate
    return if @calculated
    input = get_input

    cycle = 1
    x = 1

    @signal_strength = 0
    @display = [nil] * 240

    input.each do |line|
      case line
      when'noop'
        save_cycle(cycle, x)
        cycle += 1
      when /^addx (-?\d+)$/
        save_cycle(cycle, x)
        save_cycle(cycle + 1, x)
        x += $1.to_i
        cycle += 2
      end
    end

    @calculated = true
  end

  def part1
    calculate
    @signal_strength
  end

  def part2
    calculate
    @display.each_slice(40).map do |line|
      line.join('')
    end.join "\n"
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def save_cycle(cycle, x)
    if cycle % 40 == 20
      @signal_strength += cycle * x
    end

    column = (cycle - 1) % 40 + 1
    @display[cycle - 1] = (column >= x && column <= x + 2) ? '█' : ' '
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 10)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
      addx 15
      addx -11
      addx 6
      addx -3
      addx 5
      addx -1
      addx -8
      addx 13
      addx 4
      noop
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx -35
      addx 1
      addx 24
      addx -19
      addx 1
      addx 16
      addx -11
      noop
      noop
      addx 21
      addx -15
      noop
      noop
      addx -3
      addx 9
      addx 1
      addx -3
      addx 8
      addx 1
      addx 5
      noop
      noop
      noop
      noop
      noop
      addx -36
      noop
      addx 1
      addx 7
      noop
      noop
      noop
      addx 2
      addx 6
      noop
      noop
      noop
      noop
      noop
      addx 1
      noop
      noop
      addx 7
      addx 1
      noop
      addx -13
      addx 13
      addx 7
      noop
      addx 1
      addx -33
      noop
      noop
      noop
      addx 2
      noop
      noop
      noop
      addx 8
      noop
      addx -1
      addx 2
      addx 1
      noop
      addx 17
      addx -9
      addx 1
      addx 1
      addx -3
      addx 11
      noop
      noop
      addx 1
      noop
      addx 1
      noop
      noop
      addx -13
      addx -19
      addx 1
      addx 3
      addx 26
      addx -30
      addx 12
      addx -1
      addx 3
      addx 1
      noop
      noop
      noop
      addx -9
      addx 18
      addx 1
      addx 2
      noop
      noop
      addx 9
      noop
      noop
      noop
      addx -1
      addx 2
      addx -37
      addx 1
      addx 3
      noop
      addx 15
      addx -21
      addx 22
      addx -6
      addx 1
      noop
      addx 2
      addx 1
      noop
      addx -10
      noop
      noop
      addx 20
      addx 1
      addx 2
      addx 2
      addx -6
      addx -11
      noop
      noop
      noop
    TEST
  end
end

if __FILE__ == $0
  today = Day10.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end
