require_relative '../../2022/day8'

RSpec.describe Day8 do
  let(:test_input) { <<~TEST_INPUT }
    30373
    25512
    65332
    33549
    35390
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'counts all visible trees' do
      expect(subject.part1).to eq 21
    end
  end

  describe '#part2' do
    it 'returns the highest possible scenic score' do
      expect(subject.part2).to eq 8
    end
  end

  describe '#visiblity' do
    it 'returns an array with visibility marked' do
      expect(subject.send :visibility).to eq [
        [1, 1, 1, 1, 1],
        [1, 1, 1, 0, 1],
        [1, 1, 0, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 1, 1, 1, 1],
      ]
    end
  end

  describe '#score' do
    it 'returns the index of the next high tree plus 1' do
      expect(subject.send :score, 5, [5, 2]).to eq 1
      expect(subject.send :score, 5, [3, 5, 3]).to eq 2
      expect(subject.send :score, 5, [4, 9]).to eq 2
    end

    it 'returns the size of the line if no high tree exists' do
      expect(subject.send :score, 5, [3]).to eq 1
      expect(subject.send :score, 5, [1, 2, 3, 4]).to eq 4
    end
  end
end
