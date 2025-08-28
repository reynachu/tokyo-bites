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
      headers: { Accept: "text/vnd.turbo-stream.html" }
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



// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["input"]

//   connect() {
//     this.timeout = null
//     this.lastQuery = ""
//   }

//   submit() {
//     const query = this.inputTarget.value.trim().toLowerCase()

//     // Ignore empty or repeated query
//     if (!query || query === this.lastQuery) return

//     this.lastQuery = query

//     clearTimeout(this.timeout)
//     this.timeout = setTimeout(() => {
//       this.element.requestSubmit()
//     }, 300) // 300ms debounce
//   }
// }







// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["input", "popover"]

//   connect() {
//     this.timeout = null
//   }

//   submit() {
//     clearTimeout(this.timeout)
//     this.timeout = setTimeout(() => {
//       if (this.inputTarget.value.trim() === "") {
//         this.popoverTarget.classList.add("d-none")
//       } else {
//         this.popoverTarget.classList.remove("d-none")
//         this.inputTarget.form.requestSubmit()
//       }
//     }, 300) // debounce 300ms
//   }
// }



// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   submit() {
//     clearTimeout(this.timeout)
//     this.timeout = setTimeout(() => {
//       this.element.form.requestSubmit()
//     }, 300)
//   }
// }
