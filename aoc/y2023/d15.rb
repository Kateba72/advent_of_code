# require 'matrix'
require_relative '../solution'

module AoC
  module Y2023
    class D15 < Solution

      def part1
        input = get_input
        input.sum { |x| hash(x) }
      end

      def part2
        input = get_input

        boxes = Array.new(256) { {} }

        input.each_with_index do |step, index|
          match = step.match /[-=]/
          label = match.pre_match
          box = hash(label)
          if match.to_s == '='
            focal = match.post_match.to_i
            if boxes[box].has_key? label
              boxes[box][label].focal = focal
            else
              boxes[box][label] = Lens.new(focal, index)
            end
          else
            boxes[box].delete(label)
          end
        end

        boxes.map.with_index do |box, box_index|
          lenses = box.values.sort_by { |lens| lens.insertion_time }
          lenses.map.with_index do |lens, lens_index|
            (box_index + 1) * (lens_index + 1) * (lens.focal)
          end.sum
        end.sum
      end

      Lens = Struct.new(:focal, :insertion_time)

      def hash(str)
        value = 0
        str.chars.each do |ch|
          value += ch.ord
          value *= 17
          value %= 256
        end
        value
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def get_input
        super.strip.split(',')
      end

      def get_test_input(number)
        <<~TEST
        TEST
      end

      AOC_YEAR = 2023
      AOC_DAY = 15
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2023::D15.new(test: false)
  today.run
end
