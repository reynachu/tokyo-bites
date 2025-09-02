import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  toggle(event) {
    const icon = event.currentTarget
    const wishlistId = icon.dataset.id
    const restaurantId = this.element.dataset.restaurantId

    // Toggle between empty and filled bookmark
    icon.classList.toggle("fa-regular")
    icon.classList.toggle("fa-solid")

    // Send AJAX to Rails
    fetch(`/restaurants/${restaurantId}/bookmarks`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ wishlist_id: wishlistId })
    })
  }
}

