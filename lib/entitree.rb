require "entitree/version"
require "entitree/node"

module Entitree
  class << self
    ##
    # Returns trees of nodes for each entity.  Will be an array
    # of root nodes.
    def trees(*entities)
      entities.map do |entity|
        Node.new(entity)
      end
    end

    ##
    # Returns the flattened list of nodes for the specified
    # entities.  Can also accept a hash of options where 
    # :filter can be a lambda to filter results.
    def nodes(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      entities = args
      filter = opts[:filter] ||= lambda{|n| true}
      entities.map do |entity|
        Node.new(entity).flatten(filter)
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
  end
end
