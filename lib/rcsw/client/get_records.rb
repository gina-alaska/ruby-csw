module RCSW
  module Client
    class GetRecords < Operation
      def reload!
        @records = nil
        @request_params = nil
      end
      
      def supported?
        super('GetRecords')
      end
      
      def all
        @records ||= self.execute
      end
      
      def execute
        raise "GetRecords not supported by target CSW" unless self.supported?
        
        results = []

        while records = self.fetch_records 
          results += records.records
        end

        results
      end
      
      def fetch_records
        @per_page ||= 100
        @request_params ||= {
          'startPosition' => 1,
          'maxRecords' => @per_page,
          'resultType' => 'results',
          'outputFormat' => 'application/xml',
          'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2"
        }
        
        format = RCSW::Records::Base.new
        request_url = self.build_url(@csw_url, 'GetRecords', capabilities.version, @request_params)
        
        request = format.read(Curl.get(request_url).body_str)
        
        return false if request.records.empty?
        
        @request_params.merge!({ 'startPosition' => request.status.next_record })        
        request
      end
      
      def count
        if @records.nil?
          format = RCSW::Records::Base.new
          request_url = self.build_url(@csw_url, 'GetRecords', capabilities.version)
          request = format.read(Curl.get(request_url).body_str)
          request.status.total
        else
          @records.count
        end
      end
    end
  end
end