require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  map = get_input true

  lowest_score = find_shortest_path(map)

  puts lowest_score
end

def part2
  puts 'Part 2:'
  map = get_input

  map.each do |line|
    original_size = line.size
    (0..3).each do |increase|
      (0..original_size-1).each do |y|
        line << (line[y] + increase) % 9 + 1
      end
    end
  end

  original_size = map.size
  (0..3).each do |increase|
    (0..original_size-1).each do |x|
      line = []
      map[x].each do |entry|
        line << (entry + increase) % 9 + 1
      end
      map << line
    end
  end

  lowest_score = find_shortest_path(map)

  puts lowest_score
end

def find_shortest_path(map)
  next_moves = []
  lowest_scores = {}
  insert_points_for(0, 0, map, 0, next_moves, lowest_scores)
  puts "distances estimated"

  while true
    next_move = next_moves.find { |x| x.present? }.pop
    if (next_move[0] == map.size - 1 && next_move[1] == map[0].size - 1)
      return next_move[2]
    end

    insert_points_for(next_move[0], next_move[1], map, next_move[2], next_moves, lowest_scores)
  end
end

def insert_points_for(x, y, map, score_until_now, next_moves, lowest_scores)
  return if lowest_scores[[x, y]]&.< score_until_now
  insert_next_point(x - 1, y, map, score_until_now, next_moves, lowest_scores)
  insert_next_point(x, y - 1, map, score_until_now, next_moves, lowest_scores)
  insert_next_point(x + 1, y, map, score_until_now, next_moves, lowest_scores)
  insert_next_point(x, y + 1, map, score_until_now, next_moves, lowest_scores)
end

def insert_next_point(x, y, map, score_until_now, next_moves, lowest_scores)
  return if x < 0 || y < 0 || x >= map.size || y >= map[0].size
  score_until_next = score_until_now + map[x][y]
  score_min_until_end = get_distance_estimate(x, y, map) + score_until_now
  unless lowest_scores[[x, y]]&.<= score_min_until_end
    next_moves[score_min_until_end] ||= []
    next_moves[score_min_until_end] << [x, y, score_until_next] if
    lowest_scores[[x, y]] = score_min_until_end
  end
end

def get_distance_estimate(x, y, map)
  if map != @last_map
    @last_map = map
    @distance_estimates = { [map.size - 1, map[0].size - 1] => map.last.last }
  end
  return 10 * map.size if x >= map.size || y >= map[0].size
  @distance_estimates[[x, y]] ||= [get_distance_estimate(x + 1, y, map), get_distance_estimate(x, y + 1, map)].min + map[x][y]
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 15)
  input.split("\n").map do |line|
    line.chars.map { |ch| ch.to_i }
  end
end

def get_test_input(number)
  <<~TEST
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
