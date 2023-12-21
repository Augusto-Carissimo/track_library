class AddTrackIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :tracks, [:title, :album_id], :unique => true
  end
end
