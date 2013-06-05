module RCSW
  module Client
    class Operation
      def initialize(csw_url)
        @csw_url = csw_url
      end
      
      def capabilities
        @capabilities ||= RCSW::Client::Capabilities.new(@csw_url).execute
      end
      
      def supported?(operation)
        capabilities.operations.collect(&:name).include?(operation)
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
      
      def all
        self.execute
      end
      
      def each(&block)
        self.all.each do |item|
          yield item
        end
      end      
    end
  end
end
