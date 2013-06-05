$: << File.join(File.dirname(__FILE__), '../lib')

require 'rcsw.rb'

client = Rcsw::Client::Base.new('http://seakgis03.alaska.edu/geoportal/csw')

# 
# client.capabilities.operations.each do |op|
#   puts op.name
#   puts "\t#{op.parameters.collect(&:name)}"
# end

# puts client.capabilities.operations.collect(&:name)

results = client.get_records
puts results.count