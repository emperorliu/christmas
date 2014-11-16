class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :recipient
      t.string :price
      t.text :description
      t.integer :user_id
      t.timestamps
    end
  end
end
