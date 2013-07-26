# RCSW

A ruby library client for the [OGC Catalogue Service](http://www.opengeospatial.org/standards/cat).  Specifically developed to consume records presented by the ESRI Geoportal CSW feed.

Developed by [GINA](http://gina.alaska.edu) for use in by the [North Slope Science Initiative](http://northslope.org)'s [Catalog](http://catalog.northslope.org) and the [EPSCoR-ACE](http://epscor.alaska.edu) [Southcentral Testcase Catalog](http://seakgis.alaska.edu/).

## Installation

Add this line to your application's Gemfile:

    gem 'rcsw'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rcsw

## Usage

#### Connect to a CSW endpoint

```Ruby
    require 'rcsw'
    client = RCSW::Client::Base.new('http://seakgis03.alaska.edu/geoportal/csw')
```

#### Get Capabilities

```Ruby
    client.capabilities.each |capability|
      puts capability
    end
```

#### Get Records

```Ruby
    client.records.each do |record|
      puts "#{record.title} - #{record.subject}"
    end 
```

#### Get Records by ID

```Ruby
  identifiers = client.records.collect{|r| r.identifier}

  single_record = client.record(identifiers.first).first
  multiple_records = client.record(identifiers.join(","))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
