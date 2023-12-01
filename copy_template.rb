require 'date'

now = DateTime.now
day = ARGV[0] || now.day
year = ARGV[1] || now.year

template = File.read('template.rb')
template_subbed = template.gsub('💙year💙', year.to_s).gsub('💙day💙', day.to_s)
filename = "#{year}/day#{year}#{day}.rb"

if File.exists? filename
  puts "File #{filename} already exists. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
else
  File.write(filename, template_subbed)
  puts "Template copied. Visit https://adventofcode.com/#{year}/day/#{day} for the task"
end


spec_template = File.read('spec_template.rb')
spec_template_subbed = spec_template.gsub('💙year💙', year.to_s).gsub('💙day💙', day.to_s)
spec_filename = "spec/#{year}/day#{year}#{day}_spec.rb"

if File.exists? spec_filename
  puts "File #{filename} already exists"
else
  File.write(spec_filename, spec_template_subbed)
end
