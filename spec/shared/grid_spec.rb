require_relative '../../aoc/shared/grid2d'
require 'active_support'
require 'active_support/core_ext/object/deep_dup'

RSpec.describe Grid2d do

  subject { Grid2d.new([[1, 2, 3], [4, 5, 6]]) }

  describe '#height' do
    it 'returns the height' do
      expect(subject.height).to eq 2
    end
  end

  describe '#width' do
    it 'returns the width' do
      expect(subject.width).to eq 3
    end
  end

  describe '#at' do
    it 'returns the element at the given position' do
      expect(subject.at(Vector[0, 0])).to eq 1
      expect(subject.at(Vector[1, 0])).to eq 2
      expect(subject.at(Vector[0, 1])).to eq 4
    end

    it 'returns the default value if the given position is invalid' do
      expect(subject.at(Vector[4, 3])).to be nil
      expect(subject.at(Vector[4, 3], 'default')).to eq 'default'
    end
  end

  describe '#at!' do
    it 'returns the element at the given position' do
      expect(subject.at!(Vector[0, 0])).to eq 1
      expect(subject.at!(Vector[1, 0])).to eq 2
      expect(subject.at!(Vector[0, 1])).to eq 4
    end

    it 'raises if the given position is invalid' do
      expect { subject.at!(Vector[4, 3]) }.to raise_error(Grid2d::OutOfBoundsError)
    end
  end

  describe '#in_bounds?' do
    it 'returns true if the given vector is in bounds' do
      expect(subject.in_bounds?(Vector[0, 0])).to eq true
      expect(subject.in_bounds?(Vector[2, 0])).to eq true
      expect(subject.in_bounds?(Vector[0, 1])).to eq true
      expect(subject.in_bounds?(Vector[2, 1])).to eq true
    end

    it 'returns false if the given vector is out of bounds' do
      expect(subject.in_bounds?(Vector[-1, 0])).to eq false
      expect(subject.in_bounds?(Vector[3, 0])).to eq false
      expect(subject.in_bounds?(Vector[0, -1])).to eq false
      expect(subject.in_bounds?(Vector[0, 2])).to eq false
      expect(subject.in_bounds?(Vector[-1, -1])).to eq false
      expect(subject.in_bounds?(Vector[-1, 2])).to eq false
      expect(subject.in_bounds?(Vector[-1, 2])).to eq false
      expect(subject.in_bounds?(Vector[3, 2])).to eq false
      expect(subject.in_bounds?(Vector[3, 2])).to eq false
    end
  end

  describe '#corners' do
    it 'returns the coordinates of the corners of the grid' do
      expect(subject.corners).to contain_exactly(
        Vector[0, 0],
        Vector[0, 1],
        Vector[2, 0],
        Vector[2, 1],
      )
    end
  end

  describe 'edges' do
    it 'returns the coordinates and normal directions of the edges of the grid' do
      expect(subject.edges.to_a).to contain_exactly(
        [Vector[0, 0], 4],
        [Vector[1, 0], 4],
        [Vector[2, 0], 4],
        [Vector[0, 0], 3],
        [Vector[0, 1], 3],
        [Vector[0, 1], 1],
        [Vector[1, 1], 1],
        [Vector[2, 1], 1],
        [Vector[2, 0], 2],
        [Vector[2, 1], 2],
      )
    end

    it 'returns the coordinates as an enumerator' do
      expect(subject.edges).to be_a Enumerator
    end
  end

  describe '#row' do
    it 'returns the nth row' do
      expect(subject.row(0)).to eq [1, 2, 3]
      expect(subject.row(1)).to eq [4, 5, 6]
    end
  end

  describe '#column' do
    it 'returns the nth column' do
      expect(subject.column(0)).to eq [1, 4]
      expect(subject.column(1)).to eq [2, 5]
      expect(subject.column(2)).to eq [3, 6]
    end
  end

  describe '#rot90_ccw' do
    it 'rotates the grid by 90 degrees counter-clockwise' do
      rotated = subject.rot90_ccw
      expect(rotated.grid).to eq [[3, 6], [2, 5], [1, 4]]
      expect(rotated.height).to eq 3
      expect(rotated.width).to eq 2
    end
  end

  describe 'rot90_cw' do
    it 'rotates the grid by 90 degrees clockwise' do
      rotated = subject.rot90_cw
      expect(rotated.grid).to eq [[4, 1], [5, 2], [6, 3]]
      expect(rotated.height).to eq 3
      expect(rotated.width).to eq 2
    end
  end

  describe 'rot180' do
    it 'rotates the grid by 180 degrees' do
      rotated = subject.rot180
      expect(rotated.grid).to eq [[6, 5, 4], [3, 2, 1]]
      expect(rotated.height).to eq 2
      expect(rotated.width).to eq 3
    end
  end

  describe 'flip_vertical' do
    it 'flips the grid vertically' do
      flipped = subject.flip_vertical
      expect(flipped.grid).to eq [[4, 5, 6], [1, 2, 3]]
      expect(flipped.height).to eq 2
      expect(flipped.width).to eq 3
    end
  end

  describe 'flip_horizontal' do
    it 'flips the grid horizontally' do
      flipped = subject.flip_horizontal
      expect(flipped.grid).to eq [[3, 2, 1], [6, 5, 4]]
      expect(flipped.height).to eq 2
      expect(flipped.width).to eq 3
    end
  end

  describe '#add_border' do
    it 'adds a border' do
      with_border = subject.add_border(0)
      expect(with_border.grid).to eq [[0, 0, 0, 0, 0], [0, 1, 2, 3, 0], [0, 4, 5, 6, 0], [0, 0, 0, 0, 0]]
      expect(with_border.height).to eq 4
      expect(with_border.width).to eq 5
    end

    it 'has configurable width and height' do
      with_border = subject.add_border(0, border_width: 1, border_height: 2)
      expect(with_border.grid).to eq [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 1, 2, 3, 0], [0, 4, 5, 6, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
      expect(with_border.height).to eq 6
      expect(with_border.width).to eq 5
    end

    it 'uses the border width for both values if only one is given' do
      with_border = subject.add_border(0, border_width: 2)
      expect(with_border.grid).to eq [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 2, 3, 0, 0], [0, 0, 4, 5, 6, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
      expect(with_border.height).to eq 6
      expect(with_border.width).to eq 7
    end
  end
end
