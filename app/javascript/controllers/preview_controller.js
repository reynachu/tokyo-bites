import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output", "box"]

  showPreview(event) {
    const input = event.target
    const file = input.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = e => {
      const box = input.closest(".photo-box")
      const img = box.querySelector("img")
      const plus = box.querySelector(".plus")

      img.src = e.target.result
      img.classList.remove("d-none")
      plus.classList.add("d-none")
    }
    reader.readAsDataURL(file)
  }

  connect() {
    this.boxTargets.forEach((box, i) => {
      box.addEventListener("click", () => {
        const input = this.inputTargets[i]
        input.click()
      })
    })
  }
}
