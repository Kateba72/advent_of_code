require 'benchmark'
require_relative 'aoc_defaults'

module AoC
  class BaseClass
    include Memoized

    AOC_YEAR = nil
    AOC_DAY = nil

    def part1
      'Not Implemented'
    end

    def part2
      'Not Implemented'
    end

    def initialize(test: false, test_input: nil)
      @test = test
      @test_input = test_input
    end

    def run
      part1_solution = ''
      part2_solution = ''
      puts "Day #{self.class::AOC_DAY}"
      Benchmark.bm(12) do |benchmark|
        benchmark.report('Input parsing') { get_input }
        benchmark.report('Part 1') { part1_solution = part1 }
        benchmark.report('Part 2') { part2_solution = part2 }
      end
      puts
      puts 'Part 1:'
      puts part1_solution
      puts
      puts 'Part 2:'
      puts part2_solution
    end

    private

    memoize def get_input
      if @test_input.present?
        @test_input
      elsif @test
        get_test_input(@test)
      else
        get_aoc_input(self.class::AOC_YEAR, self.class::AOC_DAY)
      end
    end

  end
end
