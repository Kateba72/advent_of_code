require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  map = get_input

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
  next_moves = PriorityQueue.new
  lowest_scores = {}
  insert_next_point(1, 0, map, 0, next_moves, lowest_scores)
  insert_next_point(0, 1, map, 0, next_moves, lowest_scores)

  loop do
    _, score_until_now, x, y = next_moves.pop
    if (x == map.size - 1 && y == map[0].size - 1)
      return score_until_now
    end

    next if lowest_scores[[x, y]]&.< score_until_now
    insert_next_point(x - 1, y, map, score_until_now, next_moves, lowest_scores)
    insert_next_point(x, y - 1, map, score_until_now, next_moves, lowest_scores)
    insert_next_point(x + 1, y, map, score_until_now, next_moves, lowest_scores)
    insert_next_point(x, y + 1, map, score_until_now, next_moves, lowest_scores)
  end
end

def insert_next_point(x, y, map, score_until_now, next_moves, lowest_scores)
  return if x < 0 || y < 0 || x >= map.size || y >= map[0].size
  score_until_next = score_until_now + map[x][y]
  score_min_until_end = get_distance_estimate(x, y, map) + score_until_now
  unless lowest_scores[[x, y]]&.<= score_until_next
    next_moves << [-score_min_until_end, score_until_next, x, y]
    lowest_scores[[x, y]] = score_until_next
  end
end

def get_distance_estimate(x, y, map)
  if map != @last_map # Memoisation resets when changing the map for part 2
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

# https://gist.github.com/PaulSanchez/a68e2b40af587dc968615f73c446e1e5
class PriorityQueue
  attr_reader :elements

  def initialize
    clear
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  alias push <<

  def peek
    @elements[1]
  end

  def pop
    max = @elements[1]
    bubble_down_and_replace(1)
    max
  end

  def clear
    @elements = [nil]
  end

  def empty?
    @elements.length < 2
  end

  private

  def bubble_up(index)
    target = @elements[index]
    loop do
      parent_index = index / 2
      if parent_index < 1 || (@elements[parent_index] <=> target) >= 0
        @elements[index] = target
        return
      end

      @elements[index] = @elements[parent_index]
      index = parent_index
    end
  end

  def bubble_down_and_replace(index)
    target = @elements.pop

    loop do
      child_index = (index * 2)

      if child_index > @elements.size - 1 && index < @elements.size
        @elements[index] = target
        return
      end

      not_the_last_element = child_index < @elements.size - 1
      left_element = @elements[child_index]
      right_element = @elements[child_index + 1]
      child_index += 1 if not_the_last_element && (right_element <=> left_element) == 1

      if (target <=> @elements[child_index]) >= 0
        @elements[index] = target
        return
      end

      @elements[index] = @elements[child_index]
      index = child_index
    end
  end
end

if __FILE__ == $0
  part1
  puts
  part2
end
