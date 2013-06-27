require 'curb'
require 'cgi'

module RCSW
  module Client
    class Base
      def initialize(csw_url)
        @csw_url = csw_url
        @limit = 100
      end
      
      def records
        RCSW::Client::GetRecords.new(@csw_url)
      end
      
      def record(ids=[])
        RCSW::Client::GetRecordById.new(@csw_url, ids)
      end
      
      def capabilities
        RCSW::Client::Capabilities.new(@csw_url)
      end      
    end
  end
end