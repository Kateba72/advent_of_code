require_relative '../solution'

module AoC
  module Y2022
    class D16 < Solution

      def part1
        valves = parse_input

        all_valves = valves.values.sum { |v| v[0] }
        next_steps = {['AA', Set.new] => 0}
        max_pressure = 0
        (1..30).each do |minute|
          these_steps = next_steps
          next_steps = {}
          these_steps.each do |key, pressure_released|
            next if max_pressure > pressure_released + all_valves * (30 - minute)
            location, open_valves = key

            unless open_valves.include?(location) || valves[location][0] <= 0
              next_key = [location, open_valves | [location]]
              next_value = pressure_released + (30 - minute) * valves[location][0]
              max_pressure = max_pressure > next_value ? max_pressure : next_value
              next_steps[next_key] = next_value unless next_steps[next_key]&.>= next_value
            end

            valves[location][1].each do |other_location|
              next_key = [other_location, open_valves]
              next_steps[next_key] = pressure_released unless next_steps[next_key]&.>= pressure_released
            end
          end
        end

        max_pressure
      end

      def part2
        valves = parse_input

        valves_to_open = valves.values.count { |v| v[0] > 0 }
        next_steps = {['AA', 'AA', Set.new] => 0}
        old_steps = {}
        max_pressure = 0
        (5..30).each do |minute|
          2.times do
            these_steps = next_steps
            next_steps = {}
            these_steps.each do |key, pressure_released|
              location, partner_location, open_valves = key
              next if max_pressure > pressure_released + unopened_valves(open_valves) * (30 - minute)
              next if open_valves.size == valves_to_open

              unless open_valves.include?(location) || valves[location][0] <= 0
                next_key = [partner_location, location, open_valves | [location]]
                next_value = pressure_released + (30 - minute) * valves[location][0]
                max_pressure = max_pressure > next_value ? max_pressure : next_value
                if old_steps[next_key]&.at(0)&.>= next_value
                  old_steps[next_key][1] = minute - 3
                else
                  next_steps[next_key] = next_value
                  old_steps[next_key] = [next_value, minute]
                end
              end

              valves[location][1].each do |other_location|
                next_key = [partner_location, other_location, open_valves]
                if old_steps[next_key]&.at(0)&.>= pressure_released
                  old_steps[next_key][1] = minute - 3
                else
                  next_steps[next_key] = pressure_released
                  old_steps[next_key] = [pressure_released, minute]
                end
              end
            end
          end
          old_steps.delete_if { |_key, value| value[1] < minute - 5 }
        end

        max_pressure
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)*$/)
          [m[1], [m[2].to_i, m[3].split(', ')]]
        end.to_h
      end

      memoize def unopened_valves(open_valves)
        parse_input.sum(0) do |key, value|
          open_valves.include?(key) ? 0 : value[0]
        end
      end

      def get_test_input(number)
        <<~TEST
          Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
          Valve BB has flow rate=13; tunnels lead to valves CC, AA
          Valve CC has flow rate=2; tunnels lead to valves DD, BB
          Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
          Valve EE has flow rate=3; tunnels lead to valves FF, DD
          Valve FF has flow rate=0; tunnels lead to valves EE, GG
          Valve GG has flow rate=0; tunnels lead to valves FF, HH
          Valve HH has flow rate=22; tunnel leads to valve GG
          Valve II has flow rate=0; tunnels lead to valves AA, JJ
          Valve JJ has flow rate=21; tunnel leads to valve II
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 16
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D16.new(test: false)
  today.run
end
