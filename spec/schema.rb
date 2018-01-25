ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models do |t|
    t.string :key
    t.string :value

    t.timestamps
  end
end
