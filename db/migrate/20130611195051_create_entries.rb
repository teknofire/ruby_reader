class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published
      t.string :categories
      t.string :url
      t.integer :feed_id

      t.timestamps
    end
  end
end
