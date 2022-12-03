require_relative '../aoc_defaults'
# require 'matrix'

class Day3
  include Memoized

  def part1
    input = get_input
    input.sum do |line|
      priority shared_item(line)
    end
  end

  def part2
    input = get_input
    input.in_groups_of(3).sum do |group|
      priority badge(group)
    end
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  def shared_item(line)
    first_compartment = line[...line.size/2].chars.to_set
    second_compartment = line[line.size/2..].chars.to_set
    (first_compartment & second_compartment).first
  end

  def badge(group)
    group.map do |line|
      line.chars.to_set
    end.reduce(&:intersection).first
  end

  def priority(char)
    char.ord >= 97 ? char.ord - 96 : char.ord - 64 + 26
  end

  memoize def get_input
    if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2022, 3)
    end.split("\n")
  end

  def get_test_input(number)
    <<~TEST
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    TEST
  end
end

if __FILE__ == $0
  today = Day3.new
  puts 'Part 1:'
  puts today.part1
  puts
  puts 'Part 2:'
  puts today.part2
end
