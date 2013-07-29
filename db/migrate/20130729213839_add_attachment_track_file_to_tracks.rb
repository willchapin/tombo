class AddAttachmentTrackFileToTracks < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.attachment :track_file
    end
  end

  def self.down
    drop_attached_file :tracks, :track_file
  end
end
