import { Controller } from "@hotwired/stimulus"
import "tom-select"

export default class extends Controller {
  connect() {
    const select = this.element
    new TomSelect(select, {
      plugins: ["remove_button"],
      create: true,
      persist: false,
      placeholder: "Select or type tags that match this place!"
    })
  }
}
