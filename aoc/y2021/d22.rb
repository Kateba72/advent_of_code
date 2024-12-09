require_relative '../solution'

module AoC
  module Y2021
    class D22 < Solution

      def part1
        input = parse_input

        reactor = Set[]
        input.each do |line|
          apply_line_with_intersect(reactor, line, -50..50)
        end

        reactor.size
      end

      def part2
        input = parse_input
        reactor = {
          -100000..100000 => {
            -100000..100000 => {
              -100000..100000 => false,
            },
          },
        }
        input.each do |line|
          apply_line(reactor, line)
        end

        sum = 0
        reactor.each do |x_range, reactor_yz|
          reactor_yz.each do |y_range, reactor_z|
            reactor_z.each do |z_range, value|
              sum += x_range.size * y_range.size * z_range.size if value
            end
          end
        end

        sum
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def apply_line_with_intersect(reactor, line, intersect)
        (line[:x_range] & intersect).each do |x|
          (line[:y_range] & intersect).each do |y|
            (line[:z_range] & intersect).each do |z|
              if line[:status]
                reactor.add([x, y, z])
              else
                reactor.delete([x, y, z])
              end
            end
          end
        end
      end

      def apply_line(reactor, line)
        in_reactor_range(reactor, line[:x_range]) do |reactor_yz|
          in_reactor_range(reactor_yz, line[:y_range]) do |reactor_z|
            in_reactor_range(reactor_z, line[:z_range]) do
              line[:status]
            end
          end
        end
      end

      def in_reactor_range(reactor, range)
        new_entries = {}
        remove_keys = []
        reactor.each do |reactor_range, value|
          next if reactor_range.end < range.begin || reactor_range.begin > range.end

          apply_range = reactor_range
          if apply_range.begin < range.begin
            new_entries[(apply_range.begin..range.begin - 1)] = value.deep_dup
            apply_range = range.begin..apply_range.end
          end
          if apply_range.end > range.end
            new_entries[range.end + 1..apply_range.end] = value.deep_dup
            apply_range = apply_range.begin..range.end
          end
          if reactor_range == apply_range
            reactor[reactor_range] = yield value
          else
            new_entries[apply_range] = yield value
            remove_keys << reactor_range
          end
        end
        remove_keys.each do |key|
          reactor.delete key
        end

        reactor.merge! new_entries
      end

      def parse_input
        get_input.split("\n").map do |line|
          if (m = line.match(/(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/))
            {
              status: m[1] == 'on',
              x_range: (m[2].to_i..m[3].to_i),
              y_range: (m[4].to_i..m[5].to_i),
              z_range: (m[6].to_i..m[7].to_i),
            }
          else
            throw "Unparsed line #{line}"
          end
        end
      end

      def get_test_input(_number)
        <<~TEST
          on x=10..12,y=10..12,z=10..12
          on x=11..13,y=11..13,z=11..13
          off x=9..11,y=9..11,z=9..11
          on x=10..10,y=10..10,z=10..10
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 22
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D22.new(test: false)
  today.run
end
