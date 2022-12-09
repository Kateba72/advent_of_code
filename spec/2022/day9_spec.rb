require_relative '../../2022/day9'

RSpec.describe Day9 do
  let(:test_input) { <<~TEST_INPUT }
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'moves the tail with the head and counts all positions' do
      expect(subject.part1).to eq 13
    end
  end

  describe '#part2' do
    it 'moves 10 knots and counts all positions' do
      expect(subject.part2).to eq 1
    end

    it 'works with a larger example' do
      larger_example = described_class.new test_input: <<~TEST_INPUT
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
      TEST_INPUT
      expect(larger_example.part2).to eq 36
    end
  end

  describe '#move' do
    it 'moves the head correctly' do
      expect(subject.send :move, [Vector[0, 0]], 'U').to eq [Vector[0, 1]]
      expect(subject.send :move, [Vector[0, 0]], 'D').to eq [Vector[0, -1]]
      expect(subject.send :move, [Vector[0, 0]], 'R').to eq [Vector[1, 0]]
      expect(subject.send :move, [Vector[0, 0]], 'L').to eq [Vector[-1, 0]]
    end

    context 'moving one tail' do
      it "doesn't adjust if the tail is near the head" do
        expect(subject.send :move, [Vector[0, 0], Vector[0, 0]], 'R').to eq [Vector[1, 0], Vector[0, 0]]
        expect(subject.send :move, [Vector[1, 0], Vector[0, 0]], 'U').to eq [Vector[1, 1], Vector[0, 0]]
        expect(subject.send :move, [Vector[1, 0], Vector[0, 0]], 'L').to eq [Vector[0, 0], Vector[0, 0]]
      end

      it 'adjusts straight if the tail is in the same row/column' do
        expect(subject.send :move, [Vector[1, 0], Vector[0, 0]], 'R').to eq [Vector[2, 0], Vector[1, 0]]
        expect(subject.send :move, [Vector[0, 1], Vector[0, 0]], 'U').to eq [Vector[0, 2], Vector[0, 1]]
      end

      it 'adjusts diagonally if the tail is not in the same row/column' do
        expect(subject.send :move, [Vector[1, 1], Vector[0, 0]], 'R').to eq [Vector[2, 1], Vector[1, 1]]
      end
    end

    context 'moving more than one tail' do
      it 'moves all the tails correctly' do
        expect(subject.send :move, [Vector[0, 0], Vector[0, 0], Vector[0, 0]], 'R').to eq [Vector[1, 0], Vector[0, 0], Vector[0, 0]]
        expect(subject.send :move, [Vector[2, 0], Vector[1, 0], Vector[0, 0]], 'R').to eq [Vector[3, 0], Vector[2, 0], Vector[1, 0]]
        expect(subject.send :move, [Vector[2, 2], Vector[1, 1], Vector[0, 0]], 'R').to eq [Vector[3, 2], Vector[2, 2], Vector[1, 1]]
      end
    end
  end
end
