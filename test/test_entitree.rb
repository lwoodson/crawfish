require_relative 'test_helper'

describe Entitree do
  describe "#trees" do
    it "should return a node for a single entity" do
      Entitree.trees(Post).map(&:path).must_equal ["Post"]
    end

    it "should return multiple nodes for multiple entities" do
      paths = Entitree.trees(Post, Author, Comment).map(&:path)
      paths.must_include "Post"
      paths.must_include "Author"
      paths.must_include "Comment"
    end
  end

  describe "#nodes" do
    it "should return the flattened nodes reachable from a root" do
      paths = Entitree.nodes(Post, Author).map(&:path)
      paths.must_include "Post"
      paths.must_include "Post/author"
      paths.must_include "Post/author/author_detail"
      paths.must_include "Post/comments"
      paths.must_include "Post/tags"
      paths.must_include "Author"
      paths.must_include "Author/author_detail"
      paths.must_include "Author/author_detail/address"
      paths.must_include "Author/address"
      paths.must_include "Author/posts"
      paths.must_include "Author/posts/comments"
      paths.must_include "Author/posts/tags"
    end

    it "should allow a filter to limit results" do
      visited_models = Set.new
      filter = lambda do |node|
        node.ref_key.match(/comment/).nil?
      end
      paths = Entitree.nodes(Post, Author, filter: filter).map(&:path)
      paths.must_include "Post/author"
      paths.wont_include "Post/comments"
      paths.wont_include "Author/posts/comments"
    end
  end

  describe "#models" do
    it "should include distinct models exactly once" do
      models = Entitree.models(Author, Acme::Product)
      models.must_include Author
      models.must_include AuthorDetail
      models.must_include Address
      models.must_include Post
      models.must_include Comment
      models.must_include Tag
      models.must_include Acme::Product
      models.must_include Acme::Feature
      models.size.must_equal 8
    end
  end
end
