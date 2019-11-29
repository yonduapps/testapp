class CreateBookGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :book_genres do |t|
      t.belongs_to :book
      t.belongs_to :genre
      t.timestamps
    end
  end
end
