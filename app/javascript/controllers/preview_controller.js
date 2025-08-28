import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output", "box", "removeBtn"]

  connect() {
    this.boxTargets.forEach((box, i) => {
      box.addEventListener("click", () => {
        const input = this.inputTargets[i]
        input.click()
      })
    })
  }

  showPreview(event) {
    const input = event.target
    const file = input.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = e => {
      const box = input.closest(".photo-box")
      const img = box.querySelector("img")
      const plus = box.querySelector(".plus")
      const removeBtn = box.querySelector(".remove-btn")

      img.src = e.target.result
      img.classList.remove("d-none")
      plus.classList.add("d-none")
      removeBtn.classList.add("visible")
    }
    reader.readAsDataURL(file)
  }

  removePhoto(event) {
    event.stopPropagation()
    const btn = event.target
    const box = btn.closest(".photo-box")
    const img = box.querySelector("img")
    const input = box.querySelector("input[type='file']")
    const plus = box.querySelector(".plus")

    img.src = ""
    img.classList.add("d-none")
    input.value = ""
    btn.classList.remove("visible")
    plus.classList.remove("d-none")
  }
}
