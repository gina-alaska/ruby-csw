module RCSW
  module Client
    class GetRecordById < Operation
      def initialize(csw_url, ids)
        @ids = Array(ids)
        super(csw_url)
      end
      
      def reload!
        @records = nil
        @request_params = nil
      end
      
      def supported?
        super('GetRecordById')
      end
      
      def all
        @records ||= self.execute
        @records
      end
      
      def execute
        raise "GetRecordById not supported by target CSW" unless self.supported?
        
        results = self.fetch_records
        records = results.records || []
        records
      end
      
      def fetch_records
        @per_page ||= 100
        @request_params ||= {
          'ElementSetName' => 'full',
          'outputFormat' => 'application/xml',
          'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2",
          'Id' => @ids.join(",")
        }
        
        format = RCSW::Records::Base.new
        request_url = self.build_url(@csw_url, 'GetRecordById', capabilities.version, @request_params)
        
        request = format.read(Curl.get(request_url).body_str)
      
        request
      end
      
      def count
        self.all.count
      end
    end
  end
end