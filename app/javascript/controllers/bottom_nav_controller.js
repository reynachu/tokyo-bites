import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.setHeight();
    // Recalculate on viewport / Turbo changes
    window.addEventListener("resize", this.setHeight, { passive: true });
    document.addEventListener("turbo:load", this.setHeight);
    document.addEventListener("turbo:frame-load", this.setHeight);
  }
  disconnect() {
    window.removeEventListener("resize", this.setHeight);
    document.removeEventListener("turbo:load", this.setHeight);
    document.removeEventListener("turbo:frame-load", this.setHeight);
  }
  setHeight = () => {
    const h = Math.ceil(this.element.getBoundingClientRect().height);
    document.documentElement.style.setProperty("--bottom-nav-h", `${h}px`);
  }
}
