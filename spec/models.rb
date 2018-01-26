class Model
end

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :images, as: :content
end

class Image < ActiveRecord::Base
  has_one :url
  belongs_to :content, polymorphic: true
end

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end

class Url < ActiveRecord::Base
  belongs_to :image
end

class Video < ActiveRecord::Base
  has_one :thumbnail, class_name: Image.name
  has_one :thumb_url, through: :thumbnail, class_name: Url.name
end

class Blog < ActiveRecord::Base
  has_many :entries, class_name: Post.name
  has_many :comments, through: :entries
  has_many :images, as: :content
end
