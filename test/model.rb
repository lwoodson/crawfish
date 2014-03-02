class Author < ActiveRecord::Base
  has_one :author_detail
  has_one :address, through: :author_detail
  has_many :posts
  has_many :comments, through: :posts
end

class Post < ActiveRecord::Base
  belongs_to :author
  has_many :comments
  has_and_belongs_to_many :tags
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class AuthorDetail < ActiveRecord::Base
  belongs_to :author
  has_one :address
end

class Address < ActiveRecord::Base
  belongs_to :author_detail
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

module Acme
  class Product < ActiveRecord::Base
    has_many :features
  end

  class Feature < ActiveRecord::Base
    belongs_to :product
  end
end
