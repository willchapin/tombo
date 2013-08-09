class AddIndexToTracks < ActiveRecord::Migration
  def change
    add_index :tracks, :id, unique: true
  end
end
