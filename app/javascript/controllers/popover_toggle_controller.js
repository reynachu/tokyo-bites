// app/javascript/controllers/popover_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["popover"]

  toggle() {
    this.popoverTarget.classList.toggle("d-none")
  }
}
