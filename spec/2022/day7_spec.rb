require_relative '../../2022/day7'

RSpec.describe Day7 do
  let(:test_input) { <<~TEST_INPUT }
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'calculates the sum of all small directories' do
      expect(subject.part1).to eq 95437
    end
  end

  describe '#part2' do
    it 'returns the smallest directory which frees up the system' do
      expect(subject.part2).to eq 24933642
    end
  end

  describe '#get_input' do
    it 'calculates information for all directories' do
      expect(subject.send :get_input).to eq({
        '/' => [nil, [[14848514, "b.txt"], [8504156, "c.dat"]], ["//a", "//d"], 48381165],
        "//a" => ["/", [[29116, "f"], [2557, "g"], [62596, "h.lst"]], ["//a/e"], 94853],
        "//a/e" => ["//a", [[584, "i"]], [], 584],
        "//d" => ["/", [[4060174, "j"], [8033020, "d.log"], [5626152, "d.ext"], [7214296, "k"]], [], 24933642],
      })
    end
  end
end
