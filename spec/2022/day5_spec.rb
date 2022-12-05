require_relative '../../2022/day5'

RSpec.describe Day5 do
  let(:test_input) { <<~TEST_INPUT }
        [D]    
    [N] [C]    
    [Z] [M] [P]
     1   2   3 

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#get_input' do
    it 'parses the instructions and the stacks' do
      expect(subject.send :get_input).to eq [
        [
          %w[Z N],
          %w[M C D],
          %w[P]
        ],
        [
          [1, 1, 0],
          [3, 0, 2],
          [2, 1, 0],
          [1, 0, 1]
        ]
      ]
    end
  end

  describe '#part1' do
    it 'moves stacks one crate at a time' do
      expect(subject.part1).to eq 'CMZ'
    end
  end

  describe '#apply_instruction_9000' do
    it 'moves a single crate' do
      stacks = [%w[Z N], %w[M C D], %w[P]]
      expect(subject.send :apply_instruction_9000, stacks, [1, 1, 0]).to eq [%w[Z N D], %w[M C], %w[P]]
    end

    it 'moves stacks one crate at a time' do
      stacks = [%w[Z N D], %w[M C], %w[P]]
      expect(subject.send :apply_instruction_9000, stacks, [3, 0, 2]).to eq [[], %w[M C], %w[P D N Z]]
    end
  end

  describe '#part2' do
    it 'moves stacks all crates at once' do
      expect(subject.part2).to eq 'MCD'
    end
  end

  describe '#apply_instruction_9001' do
    it 'moves a single crate' do
      stacks = [%w[Z N], %w[M C D], %w[P]]
      expect(subject.send :apply_instruction_9001, stacks, [1, 1, 0]).to eq [%w[Z N D], %w[M C], %w[P]]
    end

    it 'moves stacks all crates at once' do
      stacks = [%w[Z N D], %w[M C], %w[P]]
      expect(subject.send :apply_instruction_9001, stacks, [3, 0, 2]).to eq [[], %w[M C], %w[P Z N D]]
    end
  end
end
