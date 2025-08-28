class AddWishlistToBookmarks < ActiveRecord::Migration[7.1]
  # Minimal AR shims at class scope (allowed)
  BookmarkShim = Class.new(ActiveRecord::Base) { self.table_name = "bookmarks" }
  WishlistShim = Class.new(ActiveRecord::Base) { self.table_name = "wishlists" }
  UserShim     = Class.new(ActiveRecord::Base) { self.table_name = "users" }

  def up
    add_reference :bookmarks, :wishlist, null: true, foreign_key: true

    if BookmarkShim.column_names.include?("user_id")
      say_with_time "Backfilling bookmarks.wishlist_id" do
        UserShim.find_each do |u|
          wl = WishlistShim.where(user_id: u.id).order(:created_at).first ||
               WishlistShim.create!(user_id: u.id)
          BookmarkShim.where(user_id: u.id, wishlist_id: nil).update_all(wishlist_id: wl.id)
        end
      end
    end

    change_column_null :bookmarks, :wishlist_id, false
    add_index :bookmarks, [:wishlist_id, :restaurant_id],
              unique: true, name: "index_bookmarks_on_wishlist_and_restaurant"
  end

  def down
    remove_index :bookmarks, name: "index_bookmarks_on_wishlist_and_restaurant" if index_exists?(:bookmarks, name: "index_bookmarks_on_wishlist_and_restaurant")
    remove_reference :bookmarks, :wishlist, foreign_key: true
  end
end
