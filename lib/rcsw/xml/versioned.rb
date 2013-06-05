module RCSW
  module XML
    class Versioned < Base
      def initialize
        super
      end
      
      def read(data, options = {})
        if data.is_a?(String)
          data = StringIO.new(data)
        end
        xml_parser = LibXML::XML::Parser.io(data)
        xml = xml_parser.parse
        root = xml.root
        version = get_version(root)
        # 
        parser = get_parser(version)
        
        capabilities = OpenStruct.new
        capabilities = parser.read_node(root, capabilities)
        capabilities.version = version
        capabilities
      end
      
      def get_parser(version)
        if @parser.nil? || @parser.class.version != version
          parser_class_name = "V#{version.to_s.gsub(/\./, "_")}"
          begin
            format = "#{self.class.name.deconstantize}::#{parser_class_name}".constantize
          rescue
            format = nil
          end
        
          if format.nil?
            parser_class_name = "V#{version.to_s.gsub(/\./, "_")}"
            begin
              format = "#{self.class.name.deconstantize}::#{parser_class_name}".constantize
            rescue
              format = nil
            end
          end
        
          if format.nil?
            raise "Can't find a parser for version #{version}"
          end
        
          @parser = format.new
        end

        @parser
      end
      
      def get_version(root, options = {})
        if root.nil?
          ver = options[:version] || self.version || self.default_version
        else
          ver = self.class.version || self.default_version
          ver = root['version'] if ver.nil?
        end
        
        ver
      end
    end
  end
end