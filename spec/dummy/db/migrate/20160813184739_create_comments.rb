class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.string :body

      t.timestamps
    end
    add_index :comments, :post_id
  end
end
