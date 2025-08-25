import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "popover"]

  connect() {
    // Toggle popover when input is focused or button clicked
    this.inputTarget.addEventListener("focus", () => {
      this.showPopover()
    })

    // Hide popover on Escape or outside click
    document.addEventListener("click", e => {
      if (!this.popoverTarget.contains(e.target) && e.target !== this.inputTarget) {
        this.hidePopover()
      }
    })

    document.addEventListener("keydown", e => {
      if (e.key === "Escape") this.hidePopover()
    })
  }

  showPopover() {
    this.popoverTarget.classList.remove("d-none")
  }

  hidePopover() {
    this.popoverTarget.classList.add("d-none")
  }

  submit(event) {
    // Trigger Turbo request for every keystroke
    // `input` event automatically triggers form submit
    this.inputTarget.form.requestSubmit()
  }
}




// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["btn", "popover"]

//   connect() {
//     this.btnTarget.addEventListener("click", e => {
//       e.stopPropagation()
//       this.popoverTarget.classList.toggle("d-none")
//       if (!this.popoverTarget.classList.contains("d-none")) {
//         this.popoverTarget.querySelector("input").focus()
//       }
//     })

//     document.addEventListener("click", e => {
//       if (!this.popoverTarget.contains(e.target) && e.target !== this.btnTarget) {
//         this.popoverTarget.classList.add("d-none")
//       }
//     })

//     document.addEventListener("keydown", e => {
//       if (e.key === "Escape") {
//         this.popoverTarget.classList.add("d-none")
//       }
//     })
//   }
// }
