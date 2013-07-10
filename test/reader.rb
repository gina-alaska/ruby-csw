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
# records.each do |r|
#   puts r.title
#   #puts r.inspect
# end
puts "Fetching records took #{Time.now - start} seconds"

#puts records.collect(&:title).inspect

puts "Testing GetRecordById"
ids = records.collect{|r| r.identifier}
start = Time.now

records_by_id = client.record(ids)

puts "Fetching #{records_by_id.count} records took #{Time.now - start} seconds"


puts "Attempting to fetch record with null id"
client.record(nil).each do |r|
  puts "Shouldn't see me -- nil id"
end

puts "Attempting to fetch a record with an invalid id"
client.record("bad_id").each do |r|
  puts "Shouldn't see me -- bad id"
end



