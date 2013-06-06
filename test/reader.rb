$: << File.join(File.dirname(__FILE__), '../lib')

require 'rcsw'

client = RCSW::Client::Base.new('http://seakgis03.alaska.edu/geoportal/csw')

# 
# client.capabilities.operations.each do |op|
#   puts op.name
#   puts "\t#{op.parameters.collect(&:name)}"
# end

# puts client.capabilities.operations.collect(&:name)


client.capabilities.each do |cap|
  puts cap.name
end

records = client.records

start = Time.now
puts records.count
puts "Count took #{Time.now - start} seconds"

start = Time.now
records.each do |r|
  puts r.title
end
puts "Fetching records took #{Time.now - start} seconds"

puts records.collect(&:title).inspect

