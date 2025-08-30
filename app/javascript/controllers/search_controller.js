import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    document.addEventListener("click", this.closeDropdown.bind(this))
  }

  submit(event) {
    const query = this.inputTarget.value
    if (query.length === 0) {
      this.resultsTarget.classList.add("d-none")
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/search?q=${encodeURIComponent(query)}`, {
      headers: { "content-type": "plain/text" }
    })
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
        this.resultsTarget.classList.remove("d-none")
      })
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add("d-none")
    }
  }
}
