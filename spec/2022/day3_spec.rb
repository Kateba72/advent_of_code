require_relative '../../2022/day3'

RSpec.describe Day3 do
  let(:test_input) { <<~TEST_INPUT }
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'sums the priorities of all shared items' do
      expect(subject.part1).to eq 157
    end
  end

  describe '#part2' do
    it 'sums the priorities of all groups' do
      expect(subject.part2).to eq 70
    end
  end

  describe '#priority' do
    it 'gets the correct priority' do
      expect(%w[a p z A L Z]).to be_mapped_by(subject, :priority).to [1, 16, 26, 27, 38, 52]
    end
  end

  describe '#shared_item' do
    it 'gets the letter that is in both halves' do
      expect(test_input.split("\n")).to be_mapped_by(subject, :shared_item).to %w[p L P v t s]
    end
  end

  describe '#badge' do
    it 'gets the letter that is in all lines' do
      inputs = [
        %w[vJrwpWtwJgWrhcsFMMfFFhFp jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL PmmdzqPrVvPwwTWBwg],
        %w[wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn ttgJtRGJQctTZtZT CrZsJsPPZsGzwwsLwLmpwMDw]
      ]
      expect(inputs).to be_mapped_by(subject, :badge).to %w[r Z]
    end
  end
end
