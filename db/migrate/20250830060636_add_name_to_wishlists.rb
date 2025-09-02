class AddNameToWishlists < ActiveRecord::Migration[7.1]
  def change
    add_column :wishlists, :name, :string
  end
end
