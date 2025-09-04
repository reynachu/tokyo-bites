import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.selectedIndex = -1
  }

  submit() {
    const query = this.inputTarget.value.trim()

    const url = query
      ? `/restaurants.json?q=${encodeURIComponent(query)}`
      : `/restaurants.json`

    fetch(url, { headers: { "Accept": "application/json" } })
      .then(res => res.json())
      .then(data => {
        if (!data.length) return this.hideResults()

        // Optional: Pan map to first result only when a query is typed
        if (query) this.goToMap(data[0])

        this.renderResults(data)
        this.selectedIndex = -1
      })
      .catch(err => console.error("Map search error:", err))
  }

  renderResults(data) {
    this.resultsTarget.innerHTML = data.map((r, index) => `
      <li class="p-2 hover-bg-light rounded d-flex align-items-center cursor-pointer"
          role="option"
          data-lat="${r.latitude}" data-lng="${r.longitude}" data-name="${r.name}"
          data-index="${index}"
          data-action="click->map-search#goToMapFromDropdown mouseover->map-search#highlightDropdown">
        <i class="fa fa-utensils me-2 text-muted"></i>
        <span>${r.name}</span>
      </li>
    `).join("")

    this.resultsTarget.classList.remove("d-none")
  }

  goToMapFromDropdown(event) {
    const li = event.currentTarget
    this.selectedIndex = parseInt(li.dataset.index)

    const restaurant = {
      name: li.dataset.name,
      latitude: parseFloat(li.dataset.lat),
      longitude: parseFloat(li.dataset.lng)
    }

    this.goToMap(restaurant)
    this.hideResults()
  }

  highlightDropdown(event) {
    this.selectedIndex = parseInt(event.currentTarget.dataset.index)
    this.updateDropdownHighlight()
  }

  keydown(event) {
    const items = Array.from(this.resultsTarget.children)
    if (!items.length) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.selectedIndex = (this.selectedIndex + 1) % items.length
      this.updateDropdownHighlight()
      this.scrollToSelected(items)
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      this.selectedIndex = (this.selectedIndex - 1 + items.length) % items.length
      this.updateDropdownHighlight()
      this.scrollToSelected(items)
    }

    if (event.key === "Enter") {
      event.preventDefault()
      if (this.selectedIndex >= 0) {
        const li = items[this.selectedIndex]
        this.goToMapFromDropdown({ currentTarget: li })
      }
    }
  }

  updateDropdownHighlight() {
    Array.from(this.resultsTarget.children).forEach((li, i) => {
      li.classList.toggle("bg-primary", i === this.selectedIndex)
      li.classList.toggle("text-white", i === this.selectedIndex)
    })
  }

  scrollToSelected(items) {
    const li = items[this.selectedIndex]
    li.scrollIntoView({ block: "nearest", behavior: "smooth" })
  }

  goToMap(restaurant) {
    const lat = restaurant.latitude
    const lng = restaurant.longitude
    const name = restaurant.name

    if (!window.map || !lat || !lng) return

    window.map.setView([lat, lng], 16)

    if (this.currentMarker) window.map.removeLayer(this.currentMarker)

    this.currentMarker = L.marker([lat, lng])
      .addTo(window.map)
      .bindPopup(`<strong>${name}</strong>`)
      .openPopup()
  }

  hideResults() {
    if (this.hasResultsTarget) this.resultsTarget.classList.add("d-none")
  }
}
