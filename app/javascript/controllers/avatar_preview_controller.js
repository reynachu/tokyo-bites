import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "img", "filename"]

  showPreview() {
    const file = this.inputTarget.files?.[0]
    if (!file) return
    const url = URL.createObjectURL(file)
    this.imgTarget.src = url
    if (this.filenameTarget) this.filenameTarget.textContent = file.name
  }
}
