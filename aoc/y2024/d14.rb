require_relative '../solution'

# https://adventofcode.com/2024/day/14
module AoC
  module Y2024
    class D14 < Solution

      def part1
        input = parse_input

        quadrant_counts = Hash.new { 0 }
        input.each do |start_pos, vel|
          later_pos = start_pos + vel * 100

          quadrant = later_pos.each2(size).map do |pos, size|
            pos %= size
            pos -= size / 2
            pos <=> 0
          end
          quadrant_counts[quadrant] += 1
        end

        [[-1, -1], [-1, 1], [1, -1], [1, 1]].map { quadrant_counts[_1] }.multiply
      end

      def part2
        input = parse_input.deep_dup

        # (0..).each do |second|
        #   grid = Array.new(size[1]) { Array.new(size[0]) { ' ' } }
        #   input.each do |pos, vel|
        #     grid[pos[0]][pos[1]] = '#'
        #
        #     pos[0] = (pos[0] + vel[0]) % size[0]
        #     pos[1] = (pos[1] + vel[1]) % size[1]
        #   end
        #
        #   puts grid.map(&:join).join("\n")
        #   puts second
        #   gets
        # end

        # Trying out the above program gets these values
        remainder_x = 62
        remainder_y = 25

        # We want to solve the system
        # x % size[0] = remainder_x
        # x % size[1] = remainder_y
        # with the chinese remainder theorem
        #
        # There exist two numbers m_x, m_y s.t. m_x * size[0] + m_y * size[1] = 1 (via extended euclidian algorithm)
        m_x, m_y = ext_euclidian(size[0], size[1])

        # Then the solution is
        solution = (remainder_x * m_y * size[1] + remainder_y * m_x * size[0]) % (size[0] * size[1])

        grid = Array.new(size[1]) { Array.new(size[0]) { ' ' } }
        input.each do |pos, vel|
          pos_y = (pos[0] + vel[0] * solution) % size[0]
          pos_x = (pos[1] + vel[1] * solution) % size[1]
          grid[pos_x][pos_y] = '#' # This program has weird coordinates
        end

        puts grid.map(&:join).join("\n")
        solution
      end

      def ext_euclidian(in_a, in_b)
        old_r = in_a
        r = in_b
        old_s = 1
        s = 0
        old_t = 0
        t = 1

        until r == 0
          q = old_r / r
          old_r, r = [r, old_r - q * r]
          old_s, s = [s, old_s - q * s]
          old_t, t = [t, old_t - q * t]
        end

        [old_s, old_t]
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
        @size = testing? ? Vector[11, 7] : Vector[101, 103]
      end

      attr_reader :size

      private

      memoize def parse_input
        get_input.split("\n").map do |robot|
          ints = robot.integers(negative: true)
          [Vector[ints[0], ints[1]], Vector[ints[2], ints[3]]]
        end
      end

      def get_test_input(_number)
        <<~TEST
          p=0,4 v=3,-3
          p=6,3 v=-1,-3
          p=10,3 v=-1,2
          p=2,0 v=2,-1
          p=0,0 v=1,3
          p=3,0 v=-2,-2
          p=7,6 v=-1,-3
          p=3,0 v=-1,-2
          p=9,3 v=2,3
          p=7,3 v=-1,2
          p=2,4 v=2,-3
          p=9,5 v=-3,-3
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 14
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D14.new(test: test)
  today.run
end
