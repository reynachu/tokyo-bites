class CreateRecommendationTags < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_tags do |t|
      t.references :recommendation, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :recommendation_tags, [:recommendation_id, :tag_id], unique: true
  end
end
