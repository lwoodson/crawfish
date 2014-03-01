require_relative 'test_helper'

describe Entitree::Node do
  let(:root_node) {Entitree::Node.new(Post)}
  let(:belongs_to_node) {Entitree::Node.new(Post, :author)}
  let(:has_one_node) {Entitree::Node.new(Author, :author_detail)}
  let(:has_one_through_node) {Entitree::Node.new(Author, :address)}
  let(:has_many_node) {Entitree::Node.new(Author, :posts)}
  let(:has_many_through_node) {Entitree::Node.new(Author, :comments)}
  let(:has_and_belongs_to_many_node) {Entitree::Node.new(Post, :tags)}

  describe "#reflection" do
    it "should be nil when a ref_key not present" do
      root_node.reflection.must_equal nil
    end

    it "should be the reflection in the model's reflection hash when ref_key present" do
      belongs_to_node.reflection.must_equal Post.reflections[:author]
    end
  end

  describe "#root?" do
    it "should be true when ref_key not present" do
      root_node.root?.must_equal true
    end

    it "should be false when ref_key present" do
      Entitree::Node.new(Post, :comments).root?.must_equal false
    end
  end

  describe "#other_model" do
    it "should result in the model on the other side of a reflection" do
      has_one_node.other_model.must_equal AuthorDetail
    end

    it "should result to nil if a root node" do
      root_node.other_model.must_be_nil
    end
  end

  describe "#has_one?" do
    it "should be true for has_one associations" do
      has_one_node.has_one?.must_equal true
    end

    it "should be true for has_one through associations" do
      has_one_through_node.has_one?.must_equal true
    end

    it "should be false for belongs_to associations" do
      belongs_to_node.has_one?.must_equal false
    end

    it "should be false for has_many associations" do
      has_many_node.has_one?.must_equal false
    end

    it "should be false for has_many_through_associations" do
      has_many_through_node.has_one?.must_equal false
    end

    it "should be false for has_and_belongs_to_many_associations" do
      has_and_belongs_to_many_node.has_one?.must_equal false
    end
  end

  describe "#belongs_to?" do
    it "should be true for belongs_to associations" do
      belongs_to_node.belongs_to?.must_equal true
    end

    it "should be false for has_many associations" do
      has_many_node.belongs_to?.must_equal false
    end

    it "should be false for has_many through associations" do
      has_many_through_node.belongs_to?.must_equal false
    end

    it "should be false for has_one associations" do
      has_one_node.belongs_to?.must_equal false
    end

    it "should be false for has_one through associations" do
      has_one_through_node.belongs_to?.must_equal false
    end

    it "should be false for has_and_belongs_to_many associations" do
      has_and_belongs_to_many_node.belongs_to?.must_equal false
    end
  end

  describe "#has_many?" do
    it "should be false for has_one associations" do
      has_one_node.has_many?.must_equal false
    end

    it "should be false for has_one through associations" do
      has_one_through_node.has_many?.must_equal false
    end

    it "should be false for belongs_to associations" do
      belongs_to_node.has_many?.must_equal false
    end

    it "should be true for has_many associations" do
      has_many_node.has_many?.must_equal true
    end

    it "should be true for has_many through associations" do
      has_many_through_node.has_many?.must_equal true
    end

    it "should be false for has_and_belongs_to_many associations" do
      has_and_belongs_to_many_node.has_many?.must_equal false
    end
  end

  describe "#has_and_belongs_to_many?" do
    it "should be false for has_one associations" do
      has_one_node.has_and_belongs_to_many?.must_equal false
    end

    it "should be false for has_one through associations" do
      has_one_through_node.has_and_belongs_to_many?.must_equal false
    end

    it "should be false for belongs_to associations" do
      belongs_to_node.has_and_belongs_to_many?.must_equal false
    end

    it "should be false for has_many associations" do
      has_many_node.has_and_belongs_to_many?.must_equal false
    end

    it "should be false for has_many through associations" do
      has_many_through_node.has_and_belongs_to_many?.must_equal false
    end

    it "should be true for has_and_belongs_to_many associations" do
      has_and_belongs_to_many_node.has_and_belongs_to_many?.must_equal true
    end
  end

  describe "#through?" do
    it "should be false for has_one associations" do
      has_one_node.through?.must_equal false
    end

    it "should be true for has_one through associations" do
      has_one_through_node.through?.must_equal true
    end

    it "should be false for belongs_to associations" do
      belongs_to_node.through?.must_equal false
    end

    it "should be false for has_many associations" do
      has_many_node.through?.must_equal false
    end

    it "should be true for has_many through associations" do
      has_many_through_node.through?.must_equal true
    end

    it "should be false for has_and_belongs_to_many associations" do
      has_and_belongs_to_many_node.through?.must_equal false
    end
  end
end
