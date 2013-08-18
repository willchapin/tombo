class ChangeTracksDescriptionType < ActiveRecord::Migration
  def up
    change_column :tracks, :description, :text
  end

  def down
    change_column :tracks, :description, :string
  end
end
