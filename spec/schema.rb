ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users do |t|
    t.string :username
    t.string :password

    t.timestamps
  end
end
