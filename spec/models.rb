class Model
end

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end

class Image < ActiveRecord::Base
  has_one :url
end

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end

class Url < ActiveRecord::Base
  belongs_to :image
end
