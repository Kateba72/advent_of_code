require_relative '../shared/priority_queue'

def find_shortest_path(start, target, map)
  next_moves = PriorityQueue.new
  lowest_scores = {}
  next_moves << [0, 0, start[0], start[1]]
  lowest_scores[[start[0], start[1]]] = 0

  loop do
    _, score_until_now, x, y = next_moves.pop
    if [x, y] == target # This can be adapted to suit your wishes
      return score_until_now
    end

    next if lowest_scores[[x, y]]&.< score_until_now

    map.neighbors_with_indexes(x, y).each do |value, nx, ny|
      next if value.ord > map[x][y].ord + 1 # You can add any restrictions on points to insert here (e.g. height difference max 1)
      score_until_next = score_until_now + scoring_function(nx, ny) # Replace scoring_function by the cost to walk this step
      score_min_until_end = score_until_now + min_distance(x, y) # min_distance should be lower than or equal to the real distance required to walk to the target
      unless lowest_scores[[nx, ny]]&.<= score_until_next
        next_moves << [-score_min_until_end, score_until_next, nx, ny]
        lowest_scores[[nx, ny]] = score_until_next
      end
    end
  end
end
