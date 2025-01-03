require_relative '../solution'

module AoC
  module Y2022
    class D07 < Solution

      def part1
        directories = parse_input

        directories.sum do |_name, directory|
          directory[3] <= 100000 ? directory[3] : 0
        end
      end

      def part2
        directories = parse_input

        total_size = directories['/'][3] - 40_000_000
        sizes = directories.map { |_name, directory| directory[3] }
        sizes.filter { |size| size >= total_size }.min
      end

      private

      memoize def parse_input
        instructions = get_input.split("\n")
        directories = {}
        directories['/'] = [nil, [], [], nil] # parent, files, directories, total size
        current_directory = nil
        instructions.each do |instruction|
          case instruction
          when '$ cd ..'
            current_directory = directories[current_directory][0]
          when '$ cd /'
            current_directory = '/'
          when /^\$ cd (.*)$/
            current_directory = "#{current_directory}/#{$1}"
          when '$ ls'
            # do nothing
          when /^dir (.*)$/
            name = "#{current_directory}/#{$1}"
            directories[current_directory][2] << name
            directories[name] = [current_directory, [], [], nil]
          when /^(\d+) (.+)$/
            directories[current_directory][1] << [$1.to_i, $2]
          else
            raise "Unknown line: #{instruction}"
          end
        end
        calculate_size '/', directories
        directories
      end

      def calculate_size(directory, directories)
        return directories[directory][3] if directories[directory][3]

        file_sizes = directories[directory][1].sum { |file| file[0] }
        directory_sizes = directories[directory][2].sum { |dir| calculate_size(dir, directories) }
        directories[directory][3] = file_sizes + directory_sizes
      end

      def get_test_input(_number)
        <<~TEST
          $ cd /
          $ ls
          dir a
          14848514 b.txt
          8504156 c.dat
          dir d
          $ cd a
          $ ls
          dir e
          29116 f
          2557 g
          62596 h.lst
          $ cd e
          $ ls
          584 i
          $ cd ..
          $ cd ..
          $ cd d
          $ ls
          4060174 j
          8033020 d.log
          5626152 d.ext
          7214296 k
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 7
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D07.new(test: false)
  today.run
end
