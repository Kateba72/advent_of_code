# frozen_string_literal: true

class RangeGroup
  include Enumerable

  attr_reader :ranges

  def initialize(*args, simplified: false)
    @ranges = args
    simplify args unless simplified
  end

  def each
    @ranges.each do |range|
      range.each(&block)
    end
  end

  def cover?(value)
    index = (0...@ranges.size).bsearch { |i| @ranges[i].begin >= value }
    index && @ranges[index].cover?(value)
  end

  def eql?(other)
    other.is_a?(RangeGroup) && @ranges == other.ranges
  end

  def intersection(other)
    RangeGroup.new(*intersection_shared(other), simplified: true)
  end

  def intersection!(other)
    @ranges = intersection_shared(other)
  end

  def union(other)
    RangeGroup.new(*union_shared(other))
  end

  def union!(other)
    simplify union_shared(other)
  end

  def size
    @ranges.sum(&:size)
  end

  def min
    @ranges.min(&:min).min
  end

  def max
    @ranges.max(&:max).max
  end

  def dup
    RangeGroup.new @ranges.dup, simplified: true
  end

  def to_s
    @ranges.map(&:to_s).join(', ')
  end

  private

  def union_shared(other)
    case other
    when Range
      ranges + [other]
    when RangeGroup
      union_shared(other.ranges)
    when Array
      ranges + other
    else
      raise "Not supported: #{other.class}"
    end
  end

  def intersection_shared(other)
    case other
    when Range
      @ranges.filter_map do |range|
        range.intersection(other) if range.cover?(other.begin) || other.cover?(range.begin)
      end
    when RangeGroup
      intersection_shared other.ranges
    when Array
      new_ranges = []
      iterator_self = ranges.to_enum
      iterator_other = other.to_enum
      begin
        next_self = iterator_self.next
        next_other = iterator_other.next
        loop do
          if next_self.empty?
            next_self = iterator_self.next
            next
          end
          if next_other.empty?
            next_other = iterator_other.next
            next
          end
          if next_self.begin <= next_other.begin
            if next_self.cover? next_other.begin
              new_ranges << (next_self & next_other)
              if next_self.max >= next_other.max
                next_other = iterator_other.next
              else
                next_self = iterator_self.next
              end
            else
              next_self = iterator_self.next
            end
          elsif next_other.cover? next_self.begin
            new_ranges << (next_self & next_other)
            if next_other.max >= next_self.max
              next_self = iterator_self.next
            else
              next_other = iterator_other.next
            end
          else
            next_other = iterator_other.next
          end
        end
      rescue StopIteration
        # Expected, do nothing
      end
      new_ranges
    end
  end

  def simplify(old_ranges)
    @ranges = []
    old_ranges.sort_by(&:first).each do |range|
      last = @ranges.last
      if last && last.max.succ >= range.begin
        @ranges[-1] = @ranges[-1] | range
      else
        @ranges << range
      end
    end
  end

end
