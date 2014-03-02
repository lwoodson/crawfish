require 'set'

module Entitree
  ##
  # A node within the graph of models from a root or entity node.
  class Node
    attr_reader :model, :ref_key, :reflection
    attr_accessor :parent
    def initialize(model, opts={})
      @model = model
      @ref_key = opts[:ref_key]
      @parent = opts[:parent]
      @reflection = opts[:reflection]
    end

    ##
    # Returns a flattened array of nodes from the node
    def flatten(filter=lambda{|n| true}, result=Set.new)
      result.add(self)
      associated_nodes.reject(&visited_models(result)).select(&filter).each do |node|
        result.add(node)
        node.flatten(filter, result)
      end
      result.to_a
    end

    def path
      if root?
        model.to_s
      else
        "#{parent.path}/#{ref_key}"
      end
    end

    def associated_nodes
      @associated_nodes ||= model.reflections.map do |key, reflection|
        Node.new(reflection.klass, ref_key: key, parent: self, reflection: reflection)
      end
    end

    def nodes_above
      associated_nodes.select(&:above?)
    end

    def nodes_below
      associated_nodes.select(&:below?)
    end

    def nodes_aside
      associated_nodes.select(&:aside?)
    end

    def locate(path)
      return self if path == model.to_s || path == ref_key.to_s

      next_element, *other_elements = path.split('/')
      if next_element == model.to_s
        next_element, *other_elements = other_elements
      end
      return self unless next_element

      next_node = associated_nodes.detect{|node| node.ref_key.to_s == next_element}
      next_node.locate(other_elements.join("/"))
    end

    def other_model
      reflection ? reflection.klass : nil
    end

    def root?
      parent.nil?
    end
    alias_method :entity?, :root?

    def has_one?
      reflection && reflection.macro == :has_one
    end

    def belongs_to?
      reflection && reflection.macro == :belongs_to
    end

    def has_many?
      reflection && reflection.macro == :has_many
    end

    def has_and_belongs_to_many?
      reflection && reflection.macro == :has_and_belongs_to_many
    end

    def through?
      reflection && reflection.options[:through].present?
    end

    alias_method :above?, :belongs_to?
    alias_method :below?, :has_many?

    def aside?
      has_one? || has_and_belongs_to_many?
    end
    
    private
    def visited_models(result)
      lambda do |node|
        result.detect{|n| n.model == node.model}
      end
    end
  end
end
