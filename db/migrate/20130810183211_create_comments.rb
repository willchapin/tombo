class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :track_id
      t.integer :user_id
      t.string :content

      t.timestamps
    end

    add_index :comments, [:track_id, :created_at]
    add_index :comments, :user_id
  end
end
