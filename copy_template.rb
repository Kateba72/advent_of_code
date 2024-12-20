require 'date'

now = DateTime.now
day = ARGV[0] || now.day
year = ARGV[1] || now.year

day, year = year, day if day.to_i > 2000

template = File.read('template.rb')
template_subbed = template
  .gsub('💙year💙', year.to_s)
  .gsub('💙day💙', day.to_s.rjust(2, '0'))
  .gsub('💙day_nlz💙', day.to_s)
filename = "aoc/y#{year}/d#{day.to_s.rjust(2, '0')}.rb"

if File.exist? filename
  puts "File #{filename} already exists. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
else
  Dir.mkdir_p "aoc/y#{year}"
  File.write(filename, template_subbed)
  puts "Template copied. Visit https://adventofcode.com/#{year}/day/#{day} for the task, solve the task at #{filename}"
  `git add #{filename}`
end
