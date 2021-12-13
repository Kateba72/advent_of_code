require 'date'

template = File.read('template.rb')
now = DateTime.now
day = ARGV[0] || now.day
year = ARGV[1] || now.year

template_subbed = template.gsub('%year%', year.to_s).gsub('%day%', day.to_s)
File.write("#{year}/#{day}.rb", template_subbed)
