require './lib/talk'
require './lib/conference'

filename = ARGV.first

conference = Conference.new

File.open(filename).each do |line|
    minutes = line.scan(/lightning|\d+/).first
    name = line.gsub(/\s*(lightning|\d+min)$/, '').chomp #strip out everything not the talk name and remove end of line/carrige rtns
    conference.add_talk Talk.new(name, minutes)
end

# Run schedule generator and print
conference.schedule_generator
conference.print_schedule