require 'curb'
require 'cgi'

module RCSW
  module Client
    class Base
      def initialize(csw_url)
        @csw_url = csw_url
      end
      
      def clear!
        @capabilities = nil
        @records = nil
        @_request_params = nil
      end
      
      def capabilities
        return @capabilities if @capabilities
        
        doc = Curl.get(self.build_url(@csw_url)).body_str
        format = RCSW::Capabilities::Base.new

        @capabilities = format.read(doc)
        @capabilities
      end
      
      def records
        @records ||= self.get_records
      end
      
      def get_records(limit = 100)
        self.clear!
        
        unless capabilities.operations.collect(&:name).include?('GetRecords')
          raise "Operation not supported by target CSW"
        end
        
        results = []
        while records = self.fetch_records(limit) do
          results += records.records
        end
        
        results
      end
      
      def fetch_records(limit = 100)
        @_request_params ||= {
          'startPosition' => 1,
          'maxRecords' => limit,
          'resultType' => 'results',
          'outputFormat' => 'application/xml',
          'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2"
        }
        
        format = RCSW::Records::Base.new
        request_url = self.build_url(@csw_url, 'GetRecords', capabilities.version, @_request_params)
        
        request = format.read(Curl.get(request_url).body_str)
        
        return false if request.records.empty?
        
        @_request_params.merge!({ 'startPosition' => request.status.next_record })        
        request
      end
      
      def build_url(wms_url, request = 'GetCapabilities', version = "2.0.2", params = {})
        params.merge!({
          'service' => 'CSW',
          'request' => request,
          'version' => version
        })

        query_string = params.map { |k,v| "#{CGI::escape(k)}=#{CGI::escape(v.to_s)}" }.join('&')
        "#{wms_url}?#{query_string}"
      end
    end
  end
end