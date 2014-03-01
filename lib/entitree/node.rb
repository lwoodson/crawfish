require 'forwardable'

module Entitree
  class Node
    attr_reader :model, :ref_key
    def initialize(model, ref_key=nil)
      @model = model
      @ref_key = ref_key
    end

    extend Forwardable
    def_delegator :model, :reflections, :reflections

    def reflection
      reflections[ref_key]
    end

    def other_model
      reflection ? reflection.klass : nil
    end

    def root?
      reflection.nil?
    end
    alias_method :entity?, :root?

    def has_one?
      reflection.macro == :has_one
    end

    def belongs_to?
      reflection.macro == :belongs_to
    end

    def has_many?
      reflection.macro == :has_many
    end

    def has_and_belongs_to_many?
      reflection.macro == :has_and_belongs_to_many
    end

    def through?
      reflection.options[:through].present?
    end
  end
end
