// app/javascript/controllers/popover_controller.js
import { Controller } from "@hotwired/stimulus"
import { Popover } from 'bootstrap'

export default class extends Controller {
  connect() {
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    popoverTriggerList.map(function (popoverTriggerEl) {
      return new Popover(popoverTriggerEl)
    })
  }
}
