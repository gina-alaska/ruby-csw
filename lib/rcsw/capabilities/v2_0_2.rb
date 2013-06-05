module Rcsw
  module Capabilities
    class V2_0_2 < Base
      self.version = '2.0.2'
      
      def initialize
        super
        
        @xml_readers = xml_readers.merge({
          'csw' => {
            'Capabilities' => lambda { |node,obj|
              obj ||= OpenStruct.new
              read_child_nodes(node, obj)
            },
            'ServiceIdentification' => lambda { |node, obj|
              obj.service_identification ||= OpenStruct.new
              read_child_nodes(node, obj.service_identification)
            },
            'Title' => lambda { |node, obj|
              obj.title = child_value(node)
            },
            'Abstract' => lambda { |node, obj|
              obj.abstract = child_value(node)
            },
            'OperationsMetadata' => lambda { |node, obj|
              obj.operations ||= []
              obj.parameters ||= []
              obj.constraints ||= []
              
              read_child_nodes(node, obj)
            },
            'Operation' => lambda { |node, obj| 
              operations = obj.operations || obj
              
              operation = OpenStruct.new({
                name: node['name'],
                parameters: [],
                constraints: []
              })
              read_child_nodes(node, operation)
              operations << operation
            },
            'Constraint' => lambda { |node, obj|
              constraints = obj.constraints || obj
              
              constraint = OpenStruct.new({
                name: node['name'],
                values: []
              })
              read_child_nodes(node, constraint)
              
              constraints << constraint
            },
            'Parameter' => lambda { |node, obj|
              params = obj.parameters || obj
              
              param = OpenStruct.new({
                name: node['name'],
                values: []
              })
              read_child_nodes(node, param)
              
              params << param
            },
            'Value' => lambda { |node, obj| 
              values = obj.values || obj
              
              values << child_value(node)
            }
            
          }
        })
      end
    end
  end
end