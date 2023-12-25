class RemoveGenreTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :genres
  end
end
