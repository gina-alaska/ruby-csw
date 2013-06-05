module Rcsw
  module Records
    class Base < ::Rcsw::XML::Versioned
      def initialize
        super
      end
      
      def default_version
        '2.0.2'
      end
    end
  end
end