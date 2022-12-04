require_relative '../../2022/day1'

RSpec.describe Day1 do
  let(:test_input) { <<~TEST_INPUT }
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#elves' do
    it 'sums all elves together' do
      expect(subject.send(:elves)).to eq [6000, 4000, 11000, 24000, 10000]
    end
  end

  describe '#part1' do
    it 'returns the calories of the elf with the most calories' do
      expect(subject.part1).to eq 24000
    end
  end

  describe '#part2' do
    it 'returns the sum of the tree elves with the most calories' do
      expect(subject.part2).to eq 45000
    end
  end
end
