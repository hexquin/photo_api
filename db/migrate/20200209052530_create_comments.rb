class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.string :owner
      t.integer :photo_id

      t.timestamps
    end
  end
end
