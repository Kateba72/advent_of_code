require 'benchmark'
require_relative 'aoc_defaults'

module AoC
  class Solution
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
      Benchmark.bm(13) do |benchmark|
        benchmark.report('Input parsing') { get_input }
        benchmark.report('Part 1') { part1_solution = part1 }
        benchmark.report('Part 2') { part2_solution = part2 } unless self.class::AOC_DAY == 25
      end
      puts
      puts 'Part 1:'
      puts part1_solution

      unless self.class::AOC_DAY == 25
        puts
        puts 'Part 2:'
        puts part2_solution
      end
    end

    private

    def testing?
      @test_input.present? || @test.present?
    end

    def debug(*args, force: false)
      p args if force || testing?
    end

    memoize def get_input
      if @test_input.present?
        @test_input
      elsif @test
        get_test_input(@test)
      else
        get_aoc_input
      end
    end

    def get_aoc_input
      year = self.class::AOC_YEAR
      day = self.class::AOC_DAY
      filename = File.join(File.dirname(__FILE__), "y#{year}/input-#{day}.txt")

      if File.exists?(filename)
        File.read(filename)
      else
        cookie = File.read(File.join(File.dirname(__FILE__), '../cookie.txt'))
        uri = URI.parse("https://adventofcode.com/#{year}/day/#{day}/input")
        resp = Net::HTTP.get(uri, { 'Cookie' => cookie, 'User-Agent' => 'kateba@posteo.de (github.com/Kateba72/advent_of_code)' })
        File.write(filename, resp)
        resp
      end
    end


  end
end
