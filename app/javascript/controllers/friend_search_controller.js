import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn", "popover"]

  connect() {
    this.btnTarget.addEventListener("click", e => {
      e.stopPropagation()
      this.popoverTarget.classList.toggle("d-none")
      if (!this.popoverTarget.classList.contains("d-none")) {
        this.popoverTarget.querySelector("input").focus()
      }
    })

    document.addEventListener("click", e => {
      if (!this.popoverTarget.contains(e.target) && e.target !== this.btnTarget) {
        this.popoverTarget.classList.add("d-none")
      }
    })

    document.addEventListener("keydown", e => {
      if (e.key === "Escape") {
        this.popoverTarget.classList.add("d-none")
      }
    })
  }
}

