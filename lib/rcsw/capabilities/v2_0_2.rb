module RCSW
  module Capabilities
    class V2_0_2 < Base
      self.version = '2.0.2'
      
      def initialize
        super
        
        node_readers.merge!({
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
              # obj.operations ||= []
              # obj.parameters ||= []
              # obj.constraints ||= []
              
              read_child_nodes(node, obj)
            },
            'Operation' => lambda { |node, obj| 
              obj.operations ||= []
              
              # operations = obj.operations || obj
              
              operation = OpenStruct.new({
                name: node['name'],
                parameters: [],
                constraints: []
              })
              read_child_nodes(node, operation)
              obj.operations << operation
            },
            'Constraint' => lambda { |node, obj|
              obj.constraints ||= []
              # constraints = obj.constraints || obj
              
              constraint = OpenStruct.new({
                name: node['name'],
                values: []
              })
              read_child_nodes(node, constraint)
              
              obj.constraints << constraint
            },
            'Parameter' => lambda { |node, obj|
              obj.parameters ||= []
              # params = obj.parameters || obj
              
              param = OpenStruct.new({
                name: node['name'],
                values: []
              })
              read_child_nodes(node, param)
              
              obj.parameters << param
            },
            'Value' => lambda { |node, obj| 
              obj.values ||= []
              # values = obj.values || obj
              
              obj.values << child_value(node)
            },
            'Keywords' => lambda { |node,obj|
              obj.keywords ||= []
              
              read_child_nodes(node, obj)
            },
            'Keyword' => lambda{ |node, obj|
              obj.keywords ||= []
              
              obj.keywords << child_value(node)
            },
            'ServiceType' => lambda{ |node, obj|
              obj.service_type = child_value(node)
            },
            'ServiceTypeVersion' => lambda{ |node, obj|
              obj.service_type_version = child_value(node)
            },
            'Fees' => lambda{ |node, obj|
              obj.fees = child_value(node)
            },
            'AccessConstraints' => lambda{ |node, obj|
              obj.access_constraints = child_value(node)
            }
          }
        })
      end
    end
  end
end