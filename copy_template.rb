require 'date'

template = File.read('template.rb')
now = DateTime.now
day = ARGV[0] || now.day
year = ARGV[1] || now.year

template_subbed = template.gsub('%year%', year.to_s).gsub('%day%', day.to_s)
filename = "#{year}/#{day}.rb"

if File.exists? filename
  puts "File #{filename} already exists"
else
  File.write("#{year}/#{day}.rb", template_subbed)
  puts "Template copied. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
end
