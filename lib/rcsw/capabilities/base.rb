module RCSW
  module Capabilities
    class Base < ::RCSW::XML::Versioned
      def initialize
        super
      end
      
      def default_version
        '2.0.2'
      end
    end
  end
end