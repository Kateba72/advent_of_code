require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'

class Day20236
  include Memoized

  def part1
    times, distances = get_input
    times = times.split(' ')[1..].map(&:to_i)
    distances = distances.split(' ')[1..].map(&:to_i)

    times.zip(distances).map do |time, distance|
      (0..time).count do |t|
        t * (time - t) > distance
      end
    end.inject(:*)

  end

  def part2
    times, distances = get_input
    time = times.split(':')[1].gsub(' ', '').to_i
    distance = distances.split(':')[1].gsub(' ', '').to_i

    start_time = (0..(time/2)).bsearch do |t|
      t * (time - t) > distance
    end
    end_time = time - start_time

    (start_time..end_time).size
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    times, distances = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2023, 6)
    end.split("\n")
    [times, distances]
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 6'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day20236.new }
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
