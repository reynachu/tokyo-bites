// app/javascript/controllers/like_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { recommendationId: Number }
  static targets = [ "button" ]

  connect() {
    this.lastTap = 0
    this.element.addEventListener("dblclick", this.onDoubleClick)
    this.element.addEventListener("touchend", this.onTouchEnd)
  }

  disconnect() {
    this.element.removeEventListener("dblclick", this.onDoubleClick)
    this.element.removeEventListener("touchend", this.onTouchEnd)
  }

  onDoubleClick = (e) => {
    // Avoid triggering when clicking UI controls directly
    if (e.target.closest("a, button, input, textarea")) return
    this.clickToggleButton()
  }

  onTouchEnd = (e) => {
    const now = Date.now()
    if (now - this.lastTap < 300) {
      // double tap
      if (!e.target.closest("a, button, input, textarea")) {
        this.clickToggleButton()
      }
    }
    this.lastTap = now
  }

  clickToggleButton() {
    // Find the like/unlike button inside the likes container
    const likesContainer = this.element.querySelector(`#${this.domId("likes")}`)
    const btn = likesContainer?.querySelector("a, button")
    btn?.click()
  }

  domId(suffix) {
    // Rails dom_id equivalent (recommendation_123_likes)
    return `recommendation_${this.recommendationIdValue}_${suffix}`
  }
}
