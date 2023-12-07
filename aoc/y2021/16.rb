require_relative '../aoc_defaults'

def part1(test=false)
  puts 'Part 1:'
  input = get_input test
  binary = input.pack('H*').unpack('B*').first
  packet = parse_packet(binary)

  puts packet[:sum_subpacket_versions] || packet[:version]

end

def part2(test=false)
  puts 'Part 2:'
  input = get_input test
  binary = input.pack('H*').unpack('B*').first
  packet = parse_packet(binary)

  puts packet[:value]
end

def parse_packet(binary)
  packet = {}

  packet[:version] = version = binary[0..2].to_i 2
  packet[:type] = type = binary[3..5].to_i 2


  if type == 4
    value_binary = ''
    start_index = 6
    loop do
      bits = binary[start_index .. start_index+4]
      value_binary << bits[1..4]

      break if bits[0] == '0'
      start_index += 5
    end
    packet[:value] = value_binary.to_i 2
    packet[:next_bit] = start_index + 5
  else # type != 4
    if binary[6] == '0'
      length_subpackets = binary[7..21].to_i 2

      packets = []
      start_index = 22
      while length_subpackets > 0
        packets << subpacket = parse_packet(binary[start_index..])
        length_subpackets -= subpacket[:next_bit]
        start_index += subpacket[:next_bit]
      end
    else # binary[6] == '1'
      num_subpackets = binary[7..17].to_i 2

      packets = []
      start_index = 18
      num_subpackets.times do
        packets << subpacket = parse_packet(binary[start_index..])
        start_index += subpacket[:next_bit]
      end
    end
    packet[:subpackets] = packets
    packet[:sum_subpacket_versions] = packets.map { |p| p[:sum_subpacket_versions] || p[:version] }.sum + version
    packet[:next_bit] = start_index

    case type
    when 0
      packet[:value] = packets.map { |p| p[:value] }.sum
    when 1
      packet[:value] = packets.map { |p| p[:value] }.reduce(1, :*)
    when 2
      packet[:value] = packets.map { |p| p[:value] }.min
    when 3
      packet[:value] = packets.map { |p| p[:value] }.max
    when 5
      packet[:value] = packets[0][:value] > packets[1][:value] ? 1 : 0
    when 6
      packet[:value] = packets[0][:value] < packets[1][:value] ? 1 : 0
    when 7
      packet[:value] = packets[0][:value] == packets[1][:value] ? 1 : 0
    end

  end

  packet
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 16)
  input.split("\n")
end

def get_test_input(number)
  %w[
    D2FE28
    38006F45291200
    EE00D40C823060
    8A004A801A8002F478
    620080001611562C8802118E34
    C0015000016115A2E0802F182340
    A0016C880162017C3686B18A3D4780
    C200B40A82
    04005AC33890
    880086C3E88112
    CE00C43D881120
    D8005AC2A8F0
    F600BC2D8F
    9C005AC2F8F0
    9C0141080250320F1802104A08
  ][number]
end

def test_all
  values = [6, 9, 14, 16, 12, 23, 31, 3, 54, 7, 9, 1, 0, 0, 1]
  (0..6).each do |i|
    part1 i
    puts "#{values[i]} expected"
    puts
  end

  (7..14).each do |i|
    part2 i
    puts "#{values[i]} expected"
    puts
  end
end

if __FILE__ == $0
  part1
  puts
  part2
end
