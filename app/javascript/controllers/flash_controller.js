import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    this.element.classList.remove("show") // triggers Bootstrap fade
    setTimeout(() => {
      this.element.remove()
    }, 150) // wait for fade animation
  }
}


// document.addEventListener("turbo:frame-load", () => {
//   const flash = document.querySelector("#flash .alert");
//   if (flash) {
//     setTimeout(() => flash.remove(), 3000); // disappear after 3 seconds
//   }
// });
