ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users do |t|
    t.string :username
    t.string :password

    t.timestamps
  end

  create_table :posts do |t|
    t.text :content
    t.references :user, null: false

    t.timestamps
  end

  create_table :comments do |t|
    t.text :content
    t.references :user
    t.references :post, null: false

    t.timestamps
  end

  create_table(:images, &:timestamps)

  create_table :urls do |t|
    t.string :value
    t.references :image

    t.timestamps
  end
end
