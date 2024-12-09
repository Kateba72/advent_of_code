require_relative '../solution'

module AoC
  module Y2022
    class D19 < Solution

      def part1
        blueprints = parse_input
        blueprints.sum do |blueprint|
          blueprint[:id] * best_geode_number(blueprint, 24)
        end
      end

      def part2
        blueprints = parse_input[0..2]
        blueprints.map do |blueprint|
          best_geode_number(blueprint, 32)
        end.multiply
      end

      private

      def best_geode_number(blueprint, minutes)
        states = [
          { minute: minutes, ore: 0, clay: 0, obsidian: 0, geode: 0, ore_robot: 1, clay_robot: 0, obsidian_robot: 0 },
        ]
        best_geodes = 0
        max_ore = [blueprint[:clay_ore], blueprint[:obsidian_ore], blueprint[:geode_ore]].max
        max_clay = blueprint[:obsidian_clay]
        max_obsidian = blueprint[:geode_obsidian]
        while states.present?
          state = states.pop

          state_closeness = state[:minute] * (state[:minute] - 1) + state[:geode] - best_geodes
          next if state_closeness <= 0

          if state[:ore_robot] > blueprint[:geode_ore] && state[:obsidian_robot] > blueprint[:geode_obsidian]
            best_geodes += state_closeness
            next
          end

          if state_closeness >= state[:minute] - 1
            # Case 1: Build an ore robot next
            if state[:ore_robot] < max_ore
              ore_build_minutes = [((blueprint[:ore_ore] - state[:ore]).to_f / state[:ore_robot]).ceil, 0].max + 1
              states.append next_state(state, :ore_robot, ore_build_minutes, [blueprint[:ore_ore], 0, 0]) if state[:minute] - ore_build_minutes > 2
            end

            # Case 2: Build a clay robot next
            if state[:clay_robot] * state[:minute] + state[:clay] < max_clay * state[:minute]
              clay_build_minutes = [((blueprint[:clay_ore] - state[:ore]).to_f / state[:ore_robot]).ceil, 0].max + 1
              states.append next_state(state, :clay_robot, clay_build_minutes, [blueprint[:clay_ore], 0, 0]) if state[:minute] - clay_build_minutes > 4
            end

            # Case 3: Build an obsidian robot next
            if state[:obsidian_robot] * state[:minute] + state[:obsidian] < max_obsidian * state[:minute] && state[:clay_robot] > 0
              obsidian_build_minutes = [
                ((blueprint[:obsidian_ore] - state[:ore]).to_f / state[:ore_robot]).ceil,
                ((blueprint[:obsidian_clay] - state[:clay]).to_f / state[:clay_robot]).ceil,
                0,
              ].max + 1
              states.append next_state(state, :obsidian_robot, obsidian_build_minutes, [blueprint[:obsidian_ore], blueprint[:obsidian_clay], 0]) if state[:minute] - obsidian_build_minutes > 2
            end
          end

          # Case 4: Build a geode robot next
          next unless state[:obsidian_robot] > 0

          geode_build_minutes = [
            ((blueprint[:geode_ore] - state[:ore]).to_f / state[:ore_robot]).ceil,
            ((blueprint[:geode_obsidian] - state[:obsidian]).to_f / state[:obsidian_robot]).ceil,
            0,
          ].max + 1
          next unless state[:minute] - geode_build_minutes > 0

          new_state = state.dup
          new_state[:minute] -= geode_build_minutes
          new_state[:ore] += state[:ore_robot] * geode_build_minutes - blueprint[:geode_ore]
          new_state[:clay] += state[:clay_robot] * geode_build_minutes
          new_state[:obsidian] += state[:obsidian_robot] * geode_build_minutes - blueprint[:geode_obsidian]
          new_state[:geode] += new_state[:minute]
          best_geodes = new_state[:geode] if new_state[:geode] > best_geodes
          states.append new_state

        end

        best_geodes
      end

      def next_state(state, robot, minutes, resources)
        new_state = state.dup
        new_state[:minute] -= minutes
        new_state[robot] += 1
        new_state[:ore] += state[:ore_robot] * minutes - resources[0]
        new_state[:clay] += state[:clay_robot] * minutes - resources[1]
        new_state[:obsidian] += state[:obsidian_robot] * minutes - resources[2]
        new_state
      end

      memoize def parse_input
        get_input.split("\n").map do |line|
          m = line.match(/^Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian.$/)
          {
            id: m[1].to_i,
            ore_ore: m[2].to_i,
            clay_ore: m[3].to_i,
            obsidian_ore: m[4].to_i,
            obsidian_clay: m[5].to_i,
            geode_ore: m[6].to_i,
            geode_obsidian: m[7].to_i,
          }
        end
      end

      def get_test_input(_number)
        <<~TEST
          Blueprint 1: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 6 clay. Each geode robot costs 2 ore and 6 obsidian.
        TEST
      end

      AOC_YEAR = 2022
      AOC_DAY = 19
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2022::D19.new(test: false)
  today.run
end
