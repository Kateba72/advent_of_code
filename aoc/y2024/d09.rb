require_relative '../solution'

# https://adventofcode.com/2024/day/9
module AoC
  module Y2024
    class D09 < Solution

      def part1
        input = parse_input

        filesystem = build_filesystem(input)
        fragmented_score(filesystem)
      end

      def part2
        input = parse_input

        filesystem = build_filesystem(input)
        defragmented_score(filesystem)
      end

      def build_filesystem(input)
        input.each_with_index.map do |i, index|
          [index.even? ? index / 2 : nil, i]
        end
      end

      def fragmented_score(filesystem)
        current_file = filesystem.pop until current_file&.first
        result = 0
        position = 0

        filesystem.each_with_index do |entry, index|
          file, size = entry

          if file
            debug_print_disk(position, file, size)
            result += (position...position + size).sum * file
            position += size
          else
            while size > 0
              cf_replacement_size = [size, current_file[1]].min
              debug_print_disk(position, current_file[0], cf_replacement_size)
              result += (position...position + cf_replacement_size).sum * current_file[0]
              position += cf_replacement_size
              size -= cf_replacement_size
              current_file[1] -= cf_replacement_size

              next unless current_file[1] <= 0
              break if filesystem.size <= index + 1

              current_file = filesystem.pop until (current_file[0] && current_file[1] > 0) || filesystem.size <= index + 1
            end
          end
        end
        reset_debug

        result += (position...position + current_file[1]).sum * current_file[0]

        result
      end

      def defragmented_score(filesystem)
        next_possible_replacement = (1..9).to_h { [_1, filesystem.size - 1] }
        result = 0
        position = 0

        filesystem.each_with_index do |entry, index|
          file, size = entry

          if file
            debug_print_disk(position, file, size)

            result += (position...position + size).sum * file
          else
            while size > 0
              search = next_possible_replacement[size]
              while search > index
                break if filesystem[search] && filesystem[search][0] && filesystem[search][1] <= size

                search -= 1
              end
              break if search <= index

              (1..size).each { next_possible_replacement[_1] = search - 1 }

              file_search, size_search = filesystem[search]
              debug_print_disk(position, file_search, size_search)
              result += (position...position + size_search).sum * file_search
              position += size_search
              size -= size_search

              filesystem[search][0] = nil
            end

          end
          position += size
        end

        reset_debug

        result
      end

      def debug_print_disk(position, file, size)
        return unless testing?

        if @debug_last_pos.nil?
          @debug_last_pos = 0
          puts
        end

        print('.' * (position - @debug_last_pos), file.to_s * size)
        @debug_last_pos = position + size
      end

      def reset_debug
        return unless testing?

        @debug_last_pos = nil
        puts
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.chars.map(&:to_i)
      end

      def get_test_input(_number)
        <<~TEST
          2333133121414131402
        TEST
      end

      AOC_YEAR = 2024
      AOC_DAY = 9
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2024::D09.new(test: test)
  today.run
end
