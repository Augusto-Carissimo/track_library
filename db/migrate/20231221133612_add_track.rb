class AddTrack < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :len
      t.integer :rating
      t.integer :count
      t.references :album, null: false, foreign_key: {on_delete: :cascade}
      t.references :genre, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
