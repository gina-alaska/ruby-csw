module RCSW
  module Records
    class V2_0_2 < Base
      self.version = '2.0.2'
      
      def initialize
        super
        
        node_readers.merge!({
          'csw' => {
            'GetRecordsResponse' => lambda { |node, obj|
              obj ||= OpenStruct.new
              read_child_nodes(node, obj)
            },
            'GetRecordByIdResponse' => lambda { |node, obj|
              obj ||= OpenStruct.new
              obj.records = [] 
              read_child_nodes(node, obj)
            },
            'Record' => lambda {|node, obj|
              records = obj.records
              record = OpenStruct.new
              
              read_child_nodes(node,record)
              records << record
            },
            'SearchStatus' => lambda { |node, obj| 
              obj.status = OpenStruct.new({
                timestamp: node['timestamp']
              })
              
              read_child_nodes(node, obj)
            },
            'SearchResults' => lambda { |node, obj| 
              status = obj.status || obj
              
              status.element_set = node['elementSet']
              status.next_record = node['nextRecord'].to_i
              status.total = node['numberOfRecordsMatched'].to_i
              status.returned_count = node['numberOfRecordsReturned'].to_i
              status.record_schema = node['recordSchema']
              
              obj.records = []              
              read_child_nodes(node, obj)
            },
            'SummaryRecord' => lambda { |node, obj|
              records = obj.records || obj
              
              record = OpenStruct.new
              read_child_nodes(node, record)
              
              records << record
            },
            'references' => lambda { |node, obj|
              obj.links ||= []
              
              link = OpenStruct.new({
                type: node['scheme'],
                url: child_value(node)
              })
              
              obj.links << link
            },  
            'WGS84BoundingBox' => lambda { |node, obj|
              obj.wgs84_bounds = OpenStruct.new
              read_child_nodes(node, obj.wgs84_bounds)
            },
            'BoundingBox' => lambda { |node, obj|
              obj.bounds = OpenStruct.new
              read_child_nodes(node, obj.bounds)
            },
            'LowerCorner' => lambda { |node, obj|
              obj.lower_corner = child_value(node)
            },
            'UpperCorner' => lambda { |node, obj|
              obj.upper_corner = child_value(node)
            },
            'identifier' => lambda { |node, obj|
              obj.identifier = child_value(node)
            },
            'title' => lambda { |node, obj|
              obj.title = child_value(node)
            },
            'subject' => lambda { |node, obj|
              obj.subjects ||= []
              obj.subjects << child_value(node)
            },
            'modified' => lambda { |node, obj|
              obj.updated_at = child_value(node)
            },
            'abstract' => lambda { |node, obj|
              obj.abstract = child_value(node)
            },
            'type' => lambda { |node, obj|
              obj.type = child_value(node)
            }
          }
        })
      end
    end
  end
end