import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { restaurantid: Number }

  connect() {
    this.icon = this.element.querySelector("i") // target the <i> inside button
  }

  addBookmark(event) {
    event.preventDefault()
    fetch(`/restaurants/${this.restaurantidValue}/bookmarks`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(response => {
      if (response.ok) {
        this.icon.classList.remove("fa-regular", "text-muted")
        this.icon.classList.add("fa-solid", "text-warning")
        this.element.dataset.action = "click->bookmark#deleteBookmark"
        this.element.setAttribute("aria-pressed", "true")
      }
    })
  }

  deleteBookmark(event) {
    event.preventDefault()
    fetch(`/restaurants/${this.restaurantidValue}/bookmarks`, {
      method: 'DELETE',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(response => {
      if (response.ok) {
        this.icon.classList.remove("fa-solid", "text-warning")
        this.icon.classList.add("fa-regular", "text-muted")
        this.element.dataset.action = "click->bookmark#addBookmark"
        this.element.setAttribute("aria-pressed", "false")
      }
    })
  }
}
