class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.string :title
      t.timestamps
    end
    add_index :tracks, [:user_id, :created_at]
  end
end
