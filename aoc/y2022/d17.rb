require_relative '../solution'

module AoC
  module Y2022
    class D17 < Solution

      ROCKS = [
        [
          [0, 0, 1, 1, 1, 1, 0],
        ],
        [
          [0, 0, 0, 1, 0, 0, 0],
          [0, 0, 1, 1, 1, 0, 0],
          [0, 0, 0, 1, 0, 0, 0],
        ],
        [
          [0, 0, 1, 1, 1, 0, 0],
          [0, 0, 0, 0, 1, 0, 0],
          [0, 0, 0, 0, 1, 0, 0],
        ],
        [
          [0, 0, 1, 0, 0, 0, 0],
          [0, 0, 1, 0, 0, 0, 0],
          [0, 0, 1, 0, 0, 0, 0],
          [0, 0, 1, 0, 0, 0, 0],
        ],
        [
          [0, 0, 1, 1, 0, 0, 0],
          [0, 0, 1, 1, 0, 0, 0],
        ],
      ]


      def part1
        wind = parse_input

        stop_count = 0
        tower = [[2, 2, 2, 2, 2, 2, 2]]
        wind_index = 0
        current_rock = nil
        rock_index = 0

        loop do
          unless current_rock
            last_line = tower.rindex { |line| line != [0, 0, 0, 0, 0, 0, 0] }
            tower[last_line + 1] ||= [0, 0, 0, 0, 0, 0, 0]
            tower[last_line + 2] ||= [0, 0, 0, 0, 0, 0, 0]
            tower[last_line + 3] ||= [0, 0, 0, 0, 0, 0, 0]
            ROCKS[rock_index].each_with_index do |line, rock_line|
              tower[last_line + 4 + rock_line] = line.dup
            end
            current_rock = last_line + 4 .. last_line + 3 + ROCKS[rock_index].size
            rock_index = (rock_index + 1) % 5
          end

          current_wind = wind[wind_index]
          wind_index = (wind_index + 1) % wind.size

          wind_movable = current_rock.none? do |rock_line|
            current_wind == '>' ?
              tower[rock_line][6] == 1 || (0..5).any? { |column| tower[rock_line][column] == 1 && tower[rock_line][column+1] == 2 } :
              tower[rock_line][0] == 1 || (1..6).any? { |column| tower[rock_line][column] == 1 && tower[rock_line][column-1] == 2 }
          end
          if wind_movable
            current_rock.each do |rock_line|
              if current_wind == '>'
                (1..6).reverse_each do |column|
                  last = tower[rock_line][column-1]
                  tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                  tower[rock_line][column] = 1 if last == 1
                end
                tower[rock_line][0] = 0 if tower[rock_line][0] == 1
              else
                (0..5).each do |column|
                  last = tower[rock_line][column+1]
                  tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                  tower[rock_line][column] = 1 if last == 1
                end
                tower[rock_line][6] = 0 if tower[rock_line][6] == 1
              end
            end
          end
          fallable = current_rock.none? do |rock_line|
            tower[rock_line].zip(tower[rock_line-1] || []).any? { |rock, below| rock == 1 && below == 2 }
          end
          if fallable
            current_rock.each do |rock_line|
              (0..6).each do |column|
                last = tower[rock_line][column] || [0, 0, 0, 0, 0, 0, 0]
                tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                tower[rock_line - 1][column] = 1 if last == 1
              end
            end
            current_rock = (current_rock.begin - 1 .. current_rock.end - 1)
          else
            current_rock.each do |line|
              tower[line].each_index { |column| tower[line][column] = tower[line][column] > 0 ? 2 : 0 }
            end
            current_rock = nil
            stop_count += 1
            break if stop_count == 2022
          end

        end

        tower.rindex { |line| line != [0, 0, 0, 0, 0, 0, 0] } # account for ground at level 0
      end

      def part2
        wind = parse_input

        stop_count = 0
        tower = [[2, 2, 2, 2, 2, 2, 2]]
        wind_index = 0
        current_rock = nil
        rock_index = 0
        rock_hash = {}
        tower_heights = {}

        loop do
          unless current_rock
            last_line = tower.rindex { |line| line != [0, 0, 0, 0, 0, 0, 0] }
            tower[last_line + 1] ||= [0, 0, 0, 0, 0, 0, 0]
            tower[last_line + 2] ||= [0, 0, 0, 0, 0, 0, 0]
            tower[last_line + 3] ||= [0, 0, 0, 0, 0, 0, 0]
            ROCKS[rock_index].each_with_index do |line, rock_line|
              tower[last_line + 4 + rock_line] = line.dup
            end

            next_hash = [rock_index, wind_index, tower[last_line-7..last_line]].flatten.join(' ')
            if rock_hash.include? next_hash
              old_stop_count, old_height = rock_hash[next_hash]
              additional_loops = (1000000000000 - stop_count) / (stop_count - old_stop_count)
              additional_steps = (1000000000000 - stop_count) % (stop_count - old_stop_count)
              return last_line + (last_line - old_height) * additional_loops + tower_heights[old_stop_count + additional_steps] - old_height
            end
            rock_hash[next_hash] = [stop_count, last_line]
            tower_heights[stop_count] = last_line

            current_rock = last_line + 4 .. last_line + 3 + ROCKS[rock_index].size
            rock_index = (rock_index + 1) % 5
          end

          current_wind = wind[wind_index]
          wind_index = (wind_index + 1) % wind.size

          wind_movable = current_rock.none? do |rock_line|
            current_wind == '>' ?
              tower[rock_line][6] == 1 || (0..5).any? { |column| tower[rock_line][column] == 1 && tower[rock_line][column+1] == 2 } :
              tower[rock_line][0] == 1 || (1..6).any? { |column| tower[rock_line][column] == 1 && tower[rock_line][column-1] == 2 }
          end
          if wind_movable
            current_rock.each do |rock_line|
              if current_wind == '>'
                (1..6).reverse_each do |column|
                  last = tower[rock_line][column-1]
                  tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                  tower[rock_line][column] = 1 if last == 1
                end
                tower[rock_line][0] = 0 if tower[rock_line][0] == 1
              else
                (0..5).each do |column|
                  last = tower[rock_line][column+1]
                  tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                  tower[rock_line][column] = 1 if last == 1
                end
                tower[rock_line][6] = 0 if tower[rock_line][6] == 1
              end
            end
          end
          fallable = current_rock.none? do |rock_line|
            tower[rock_line].zip(tower[rock_line-1] || []).any? { |rock, below| rock == 1 && below == 2 }
          end
          if fallable
            current_rock.each do |rock_line|
              (0..6).each do |column|
                last = tower[rock_line][column] || [0, 0, 0, 0, 0, 0, 0]
                tower[rock_line][column] = 0 if tower[rock_line][column] == 1
                tower[rock_line - 1][column] = 1 if last == 1
              end
            end
            current_rock = (current_rock.begin - 1 .. current_rock.end - 1)
          else
            current_rock.each do |line|
              tower[line].each_index { |column| tower[line][column] = tower[line][column] > 0 ? 2 : 0 }
            end
            current_rock = nil
            stop_count += 1
            break if stop_count == 1000000000000
          end

        end
      end

      private

      memoize def parse_input
        get_input.strip
      end

      def get_test_input(number)
        <<~TEST
          >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 17
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D17.new(test: false)
  today.run
end
