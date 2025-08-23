import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "results"]
  static values = { url: String }

  connect() {
    console.log("Autocomplete controller connected")

    this.resultsTarget.style.display = "none"

    this.inputTarget.addEventListener("input", () => this.search())
    window.addEventListener("resize", () => this.positionDropdown())

    this.handleClickOutsideBound = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutsideBound)

    this.handleEscapeBound = this.handleEscape.bind(this)
    document.addEventListener("keydown", this.handleEscapeBound)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutsideBound)
    document.removeEventListener("keydown", this.handleEscapeBound)
  }

  search() {
    const query = this.inputTarget.value.trim()
    if (!query) {
      this.clearResults()
      return
    }

    const url = `${this.urlValue.trim()}?q=${encodeURIComponent(query)}`
    console.log("Fetching:", url)

    fetch(url)
      .then(res => res.json())
      .then(data => this.showResults(data))
      .catch(err => {
        console.error("Autocomplete fetch error:", err)
        this.clearResults()
      })
  }

  showResults(restaurants) {
    console.log("showResults called", restaurants)
    this.resultsTarget.innerHTML = ""

    if (restaurants.length === 0) {
      this.resultsTarget.style.display = "none"
      return
    }

    restaurants.forEach(r => {
      const item = document.createElement("div")
      item.classList.add("list-group-item", "list-group-item-action")
      item.textContent = r.name
      item.addEventListener("click", () => this.selectRestaurant(r))
      this.resultsTarget.appendChild(item)
    })

    this.resultsTarget.style.display = "block"
  }

  selectRestaurant(restaurant) {
    this.inputTarget.value = restaurant.name
    this.hiddenTarget.value = restaurant.id
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.style.display = "none"
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.clearResults()
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.clearResults()
    }
  }

  positionDropdown() {
    const rect = this.inputTarget.getBoundingClientRect()
    this.resultsTarget.style.left = rect.left + window.scrollX + "px"
    this.resultsTarget.style.top = rect.bottom + window.scrollY + "px"
    this.resultsTarget.style.width = rect.width + "px"
  }
}
