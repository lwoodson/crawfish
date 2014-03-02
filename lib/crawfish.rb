require "crawfish/version"
require "crawfish/node"

module Crawfish
  class << self
    attr_accessor :node_decorator

    ##
    # Returns trees of nodes for each entity.  Will be an array
    # of root nodes.
    def trees(*args)
      opts, *entities = extract(*args)
      node_decorator = opts[:node_decorator] || NoOpDecorator
      entities.map do |entity|
        node_decorator.decorate(Node.new(entity, node_decorator: node_decorator))
      end
    end

    ##
    # Returns the flattened list of nodes for the specified
    # entities.  Can also accept a hash of options where 
    # :filter can be a lambda to filter results.
    def nodes(*args)
      opts, *entities = extract(*args)
      filter = opts[:filter] ||= lambda{|n| true}
      node_decorator = opts[:node_decorator] || NoOpDecorator
      entities.map do |entity|
        node_decorator.decorate(Node.new(entity, node_decorator: node_decorator)).flatten(filter)
      end.flatten
    end

    ##
    # Returns the unique list of models in the graphs
    # from the specified entities.
    def models(*entities)
      visited_models = Set.new
      filter = lambda {|n| visited_models.add?(n.model)}
      nodes(*entities, filter: filter).map(&:model)
    end

    private
    def extract(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      entities = args
      [opts] + entities
    end

    class NoOpDecorator
      def self.decorate(node)
        node
      end
    end
  end
end
