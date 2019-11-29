class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.datetime :publish_date
      t.timestamps
    end
    add_index :books, :title
    add_index :books, :isbn
    add_index :books, :publish_date
  end
end
