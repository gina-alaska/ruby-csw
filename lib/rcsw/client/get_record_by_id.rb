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
        self.fetch_records
      end
      
      def fetch_records
        @per_page ||= 10
        count = 0
        records = []
        
        while count < @ids.count
          id_string = @ids[count...count+@per_page].join(',')
          @request_params ||= {
            'ElementSetName' => 'full',
            'outputFormat' => 'application/xml',
            'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2",
            'Id' => id_string
          }
        
          format = RCSW::Records::Base.new
          request_url = self.build_url(@csw_url, 'GetRecordById', capabilities.version, @request_params)
          records += format.read(Curl.get(request_url).body_str).records
          count += @per_page
        end
        
        records
      end
      
      def count
        self.all.count
      end
    end
  end
end