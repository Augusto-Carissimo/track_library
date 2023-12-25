class RemoveTracksColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :tracks, :genre_id
  end
end
