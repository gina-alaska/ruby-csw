module RCSW
  module Client
    class Capabilities < Operation
      def supported?
        # this is a required operation for CSW
        true
      end
      
      def execute
        doc = Curl.get(self.build_url(@csw_url)).body_str
        format = RCSW::Capabilities::Base.new
        format.read(doc)
      end
      
      def each(&block)
        self.execute.operations.each do |item|
          yield item
        end
      end 
    end
  end
end