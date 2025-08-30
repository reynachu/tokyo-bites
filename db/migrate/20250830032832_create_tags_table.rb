class CreateTagsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :category
      t.timestamps
    end
  end
end
