class AddAddressJpToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :address_jp, :string
  end
end
