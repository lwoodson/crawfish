module Entitree
  class Node
    attr_reader :model, :ref_key, :reflection
    attr_accessor :parent
    def initialize(model, opts={})
      @model = model
      @ref_key = opts[:ref_key]
      @parent = opts[:parent]
      @reflection = opts[:reflection]
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
      associated_nodes.select{|node| node.belongs_to?}
    end

    def nodes_below
      associated_nodes.select{|node| node.has_many?}
    end

    def nodes_aside
      associated_nodes.select{|node| node.has_one? || node.has_and_belongs_to_many?}
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
  end
end
