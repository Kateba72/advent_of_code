require_relative '../solution'

module AoC
  module Y2021
    class D10 < Solution

      def part1
        points = { nil => 0, ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }.freeze
        input = parse_input

        input.sum do |line|
          line = dechunkify(line)
          corrupted = line.chars.find { _1.in? ')]>}' }
          points[corrupted]
        end
      end

      def part2
        points = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }.freeze
        input = parse_input

        scores = input.filter_map do |line|
          line = dechunkify(line)
          corrupted = line.chars.find { _1.in? ')]>}' }
          next if corrupted

          score = 0
          line.chars.reverse.each do |c|
            score *= 5
            score += points[c]
          end
          score
        end

        scores.sort[(scores.size - 1) / 2]
      end

      def dechunkify(line)
        line_was = nil
        until line_was == line
          line_was = line
          line = line.gsub('()', '').gsub('[]', '').gsub('{}', '').gsub('<>', '')
        end

        line
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n")
      end

      def get_test_input(_number)
        <<~TEST
          [({(<(())[]>[[{[]{<()<>>
          [(()[<>])]({[<{<<[]>>(
          {([(<{}[<>[]}>{[]{[(<()>
          (((({<>}<{<{<>}{[]{[]{}
          [[<[([]))<([[{}[[()]]]
          [{[{({}]{}}([{[{{{}}([]
          {<[[]]>}<{[{[{[]{()[[[]
          [<(<(<(<{}))><([]([]()
          <{([([[(<>()){}]>(<<{{
          <{([{{}}[<[[[<>{}]]]>[]]
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 10
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D10.new(test: false)
  today.run
end
