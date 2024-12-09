require_relative '../solution'

module AoC
  module Y2021
    class D13 < Solution

      def part1
        points, instructions = parse_input

        points = execute_instruction(points, instructions.first)

        points.count
      end

      def part2
        points, instructions = parse_input

        instructions.each do |instruction|
          points = execute_instruction(points, instruction)
        end
        max_row = points.map(&:last).max + 1
        max_col = points.map(&:first).max + 1

        output = (1..max_row).map { |_| ' ' * max_col }
        points.each do |point|
          output[point[1]][point[0]] = '▮'
        end

        output
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def parse_input
        points, instructions = get_input.split("\n\n")
        points = points.split("\n").map do |line|
          x, y = line.split(',')
          [x.to_i, y.to_i]
        end
        instructions = instructions.split("\n").map do |line|
          /fold along ([xy])=(\d+)/.match line do |m|
            {
              value_x: m[1] == 'x' ? m[2].to_i : nil,
              value_y: m[1] == 'y' ? m[2].to_i : nil,
            }
          end
        end
        [points, instructions]
      end

      def execute_instruction(points, instruction)
        points.map do |point|
          new_x = instruction[:value_x] && point[0] > instruction[:value_x] ? 2 * instruction[:value_x] - point[0] : point[0]
          new_y = instruction[:value_y] && point[1] > instruction[:value_y] ? 2 * instruction[:value_y] - point[1] : point[1]
          [new_x, new_y]
        end.uniq
      end

      def get_test_input(_number)
        <<~TEST
          6,10
          0,14
          9,10
          0,3
          10,4
          4,11
          6,0
          6,12
          4,1
          0,13
          10,12
          3,4
          3,0
          8,4
          1,10
          2,14
          8,10
          9,0

          fold along y=7
          fold along x=5
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 13
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D13.new(test: false)
  today.run
end
