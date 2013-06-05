require 'curb'
require 'cgi'

module Rcsw
  module Client
    class Base
      attr_accessor :results
      
      def initialize(csw_url)
        @csw_url = csw_url
        @capabilities = nil
        @current_request = nil
        @results = []
        
      end
      
      def capabilities
        return @capabilities if @capabilities
        
        doc = Curl.get(self.class.build_url(@csw_url)).body_str
        format = Rcsw::Capabilities::Base.new

        @capabilities = format.read(doc)
        @capabilities
      end
      
      def get_records(search = nil, limit = 5)
        unless capabilities.operations.collect(&:name).include?('GetRecords')
          raise "Operation not supported by target CSW"
        end

        @request_params = nil
        @start = nil
        
        params = {
          'maxRecords' => limit,
          'resultType' => 'results',
          'outputFormat' => 'application/xml',
          'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2"
        } 
      
        # records = self.fetch_records(@csw_url, 'GetRecords', capabilities.version, params)
        # results << records.results unless records.status.returned_total 
        
        while records = self.fetch_records do
          results << records.records
        end
        
        results.flatten!
      end
      
      def fetch_records(limit = 100)
        @start ||= 1
        @request_params ||= {
          'startPosition' => @start,
          'maxRecords' => limit,
          'resultType' => 'results',
          'outputFormat' => 'application/xml',
          'outputSchema' => "http://www.opengis.net/cat/csw/2.0.2"
        }
        
        format = Rcsw::Records::Base.new
        request_url = self.class.build_url(@csw_url, 'GetRecords', capabilities.version, @request_params)
        @request = format.read(Curl.get(request_url).body_str)
        
        return false if @request.records.empty?
        
        @request_params.merge!({ 'startPosition' => @request.status.next_record })        
        @request
      end
      
      class << self
        # def get_map(wms_url, layer_name, bbox = [], width = 128, height = 128, srs = 'EPSG:4326', params = {})
        #   build_map_request(wms_url, layer_name, bbox, width, height, srs, params)
        # end

        def build_url(wms_url, request = 'GetCapabilities', version = "2.0.2", params = {})
          params.merge!({
            'service' => 'CSW',
            'request' => request,
            'version' => version
          })

          query_string = params.map { |k,v| "#{CGI::escape(k)}=#{CGI::escape(v.to_s)}" }.join('&')
          "#{wms_url}?#{query_string}"
        end

        # def build_map_request(wms_url, layer_name, bbox = [], width = 128, height = 128, srs = 'EPSG:4326', params = {})
        #   params.merge!({
        #     'format' => 'image/png',
        #     'transparent' => true,
        #     'layers' => layer_name,
        #     'styles' => '',
        #     'height' => height,
        #     'width' => width,
        #     'crs'   => srs,
        #     'bbox'  => bbox.any? ? bbox.join(',') : [11.544243804517265, -0.2895834470186168, 11.802380437565015, -0.0314468139708675].join(',')
        #   })
        # 
        #   build_wms_url(wms_url, 'GetMap', '1.3.0', params)
        # end
      end
    end
  end
end