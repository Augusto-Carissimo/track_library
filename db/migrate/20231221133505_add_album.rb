class AddAlbum < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.references :artist, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
    add_index :albums, :title, unique: true
  end
end
