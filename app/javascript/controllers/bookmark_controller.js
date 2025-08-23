// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static values = { restaurantid: Number }
//   // static targets = ["button"]

//   connect() {
//     // console.log("bookmark_controller")
//     // console.log(this.element)
//     // console.log(this.restaurantidValue)

//     // console.log(this.buttonTarget) // <button ...>
//     // console.log(this.hasButtonTarget) // true
//   }

//   addBookmark(event) {
//     // event.preventDefault()
//     // this.element.className = "fa-bookmark fa-solid fa-lg"
//     // fetch(`/bookmarks/${this.restaurantIdValue}`,  {method: 'POST'});
//     // console.log(this.restaurantidValue)
//     // console.log(this.element);
//     console.log(this.element.dataset.action);

//     fetch(`/restaurants/${this.restaurantidValue}/bookmarks`, { method: 'POST'})
//       .then(response =>{
//         console.log(response);
//         if (response.status === 204)
//           {this.element.className = "fa-bookmark fa-solid fa-lg"
//             this.element.dataset.action ='click->bookmark#deleteBookmark'
//           }
//       }
//     )
//   }

//   deleteBookmark(event) {
//   // event.preventDefault()
//     fetch(`/restaurants/${this.restaurantidValue}/bookmarks`, { method: 'DELETE' })
//       .then(response =>{
//         console.log(response);
//         if (response.ok)
//           {this.element.className = "fa-bookmark fa-regular fa-lg"
//                         this.element.dataset.action ='click->bookmark#addBookmark'

//           }
//       }
//     )
//   }
// }
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { restaurantId: Number } // or restaurantid: Number

  get csrfToken() {
    const el = document.querySelector('meta[name="csrf-token"]')
    return el && el.content
  }

  addBookmark() {
    fetch(`/restaurants/${this.restaurantIdValue}/bookmarks`, {
      method: 'POST',
      headers: { 'X-CSRF-Token': this.csrfToken, 'Accept': 'application/json' },
      credentials: 'same-origin'
    }).then((response) => {
      if (response.status === 204) {
        this.element.className = "fa-bookmark fa-solid fa-lg"
        this.element.dataset.action = 'click->bookmark#deleteBookmark'
      }
    })
  }

  deleteBookmark() {
    fetch(`/restaurants/${this.restaurantIdValue}/bookmarks`, {
      method: 'DELETE',
      headers: { 'X-CSRF-Token': this.csrfToken, 'Accept': 'application/json' },
      credentials: 'same-origin'
    }).then((response) => {
      if (response.status === 204) {
        this.element.className = "fa-bookmark fa-regular fa-lg"
        this.element.dataset.action = 'click->bookmark#addBookmark'
      }
    })
  }
}









