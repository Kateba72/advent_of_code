require 'date'

now = DateTime.now
day = ARGV[0] || now.day
year = ARGV[1] || now.year

day, year = year, day if day > 2000

template = File.read('template.rb')
template_subbed = template.gsub('💙year💙', year.to_s).gsub('💙day💙', day.to_s.ljust(2, '0'))
filename = "aoc/y#{year}/d#{day}.rb"

if File.exists? filename
  puts "File #{filename} already exists. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
else
  File.write(filename, template_subbed)
  puts "Template copied. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
  %x( git add #{filename} )
end
