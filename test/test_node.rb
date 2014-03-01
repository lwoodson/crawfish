require_relative 'test_helper'

describe Entitree::Node do
  let(:root_node) {Entitree::Node.new(Author)}
  let(:child_node) {Entitree::Node.new(Post, ref_key: :posts, parent: root_node)}
  let(:grandchild_node) {Entitree::Node.new(Comment, ref_key: :comments, parent: child_node)}
  let(:belongs_to_node) {
    Entitree::Node.new(Post, reflection: Post.reflections[:author])
  }
  let(:has_one_node) {
    Entitree::Node.new(Author, reflection: Author.reflections[:author_detail])
  }
  let(:has_one_through_node) {
    Entitree::Node.new(Author, reflection: Author.reflections[:address])
  }
  let(:has_many_node) {
    Entitree::Node.new(Author, reflection: Author.reflections[:posts])
  }
  let(:has_many_through_node) {
    Entitree::Node.new(Author, reflection: Author.reflections[:comments])
  }
  let(:has_and_belongs_to_many_node) {
    Entitree::Node.new(Post, reflection: Post.reflections[:tags])
  }

  describe "#reflection" do
    it "should be nil when a ref_key not present" do
      root_node.reflection.must_equal nil
    end

    it "should be the reflection in the model's reflection hash when ref_key present" do
      belongs_to_node.reflection.must_equal Post.reflections[:author]
    end
  end

  describe "#path" do
    it "should be the model when it is a root/entity" do
      root_node.path.must_equal "Author"
    end

    it "should be the root model joined with associations using a / separator if not a root" do
      child_node.path.must_equal "Author/posts"
    end

    it "should work with arbitrarily nested associations" do
      grandchild_node.path.must_equal "Author/posts/comments"
    end
  end

  describe "#associated_nodes" do
    subject {Entitree::Node.new(Author)}
    let(:associated_node_paths) {subject.associated_nodes.map(&:path)}

    it "should include has_one nodes" do
      associated_node_paths.must_include "Author/author_detail"
    end

    it "should include has_one through nodes" do
      associated_node_paths.must_include "Author/address"
    end

    it "should include has_many nodes" do
      associated_node_paths.must_include "Author/posts"
    end

    it "should include has_many through nodes" do
      associated_node_paths.must_include "Author/comments"
    end

    it "should include has_and_belongs_to_many nodes" do
      Entitree::Node.new(Post).associated_nodes.map(&:path).must_include "Post/tags"
    end
  end

  describe "#nodes_above" do
    it "should only include nodes for belongs_to relationships" do
      Entitree::Node.new(Post).nodes_above.map(&:path).must_equal ["Post/author"]
    end
  end

  describe "#nodes_below" do
    it "should include only nodes for the has_many relationships of the node's model" do
      paths = Entitree::Node.new(Author).nodes_below.map(&:path)
      paths.must_include "Author/posts"
      paths.must_include "Author/comments"
      paths.wont_include "Author/author_detail"
      paths.wont_include "Author/address"
    end
  end

  describe "#nodes_aside" do
    it "should include only nodes for the has_one and has_and_belongs_to_many relationships" do
      paths = Entitree::Node.new(Author).nodes_aside.map(&:path)
      paths.must_include "Author/author_detail"
      paths.must_include "Author/address"
      paths.wont_include "Author/posts"
      paths.wont_include "Author/comments"
    end
  end

  describe "#root?" do
    it "should be true when ref_key not present" do
      root_node.root?.must_equal true
    end

    it "should be false when ref_key present" do
      child_node.root?.must_equal false
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
