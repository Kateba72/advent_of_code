require_relative '../aoc_defaults'
require 'benchmark'
require 'matrix'

class Day202017
  include Memoized

  def part1
    input = get_input
    active = Set.new
    input.split("\n").each_with_index do |line, x|
      line.chars.each_with_index do |char, y|
        next if char == '.'
        active << [x, y, 0]
      end
    end

    borders = [0..input.split("\n").size - 1, 0..input.index("\n") - 1, 0..0]

    6.times do
      active, borders = do_3d_conway(active, borders)
    end

    active.size
  end

  def part2
    input = get_input

    active = Set.new
    input.split("\n").each_with_index do |line, x|
      line.chars.each_with_index do |char, y|
        next if char == '.'
        active << [x, y, 0, 0]
      end
    end

    borders = [(0..input.split("\n").size - 1).to_a, (0..input.index("\n") - 1).to_a, [0], [0]]

    6.times do
      active, borders = do_4d_conway(active, borders)
    end

    active.size
  end

  def do_3d_conway(old_active, old_borders)
    new_active = Set.new
    new_borders = old_borders.map do |old_border|
      (old_border.first - 1)..(old_border.last + 1)
    end

    new_borders[0].each do |x|
      new_borders[1].each do |y|
        new_borders[2].each do |z|
          surrounding_count = (([old_borders[0].first, x-1].max)..([old_borders[0].last, x+1].min)).sum do |other_x|
            (([old_borders[1].first, y-1].max)..([old_borders[1].last, y+1].min)).sum do |other_y|
              (([old_borders[2].first, z-1].max)..([old_borders[2].last, z+1].min)).count do |other_z|
                old_active.include? [other_x, other_y, other_z]
              end
            end
          end
          if old_active.include? [x, y, z]
            new_active << [x, y, z] if surrounding_count == 3 || surrounding_count == 4
          else
            new_active << [x, y, z] if surrounding_count == 3
          end
        end
      end
    end

    [new_active, new_borders]
  end

  def do_4d_conway(old_active, old_borders)
    new_active = Set.new
    new_borders = old_borders.map do |old_border|
      ((old_border.first - 1)..(old_border.last + 1)).to_a
    end

    [nil].product(*new_borders).each do |_, x, y, z, w|
      surrounding_count = 0
      [nil].product(
        (([old_borders[0].first, x-1].max)..([old_borders[0].last, x+1].min)).to_a,
        (([old_borders[1].first, y-1].max)..([old_borders[1].last, y+1].min)).to_a,
        (([old_borders[2].first, z-1].max)..([old_borders[2].last, z+1].min)).to_a,
        (([old_borders[3].first, w-1].max)..([old_borders[3].last, w+1].min)).to_a,
      ).each do |_other, other_x, other_y, other_z, other_w|
        next unless old_active.include? [other_x, other_y, other_z, other_w]
        surrounding_count += 1
        break if surrounding_count > 4
      end

      if old_active.include? [x, y, z, w]
        new_active << [x, y, z, w] if surrounding_count == 3 || surrounding_count == 4
      else
        new_active << [x, y, z, w] if surrounding_count == 3
      end
    end

    [new_active, new_borders]
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
      get_aoc_input(2020, 17)
    end
  end

  def get_test_input(number)
    <<~TEST
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 17'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day202017.new }
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
