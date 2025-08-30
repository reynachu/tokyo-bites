import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import { Carousel } from "bootstrap"

document.addEventListener("turbo:load", () => {
  // Ensure each .carousel has an instance (manual only)
  document.querySelectorAll(".carousel").forEach((el) => {
    Carousel.getOrCreateInstance(el, {
      interval: false, ride: false, touch: true, keyboard: true, pause: false
    });
  });

  // Prev/Next buttons — drive the nearest carousel
  document.querySelectorAll(".carousel .carousel-control-prev").forEach((btn) => {
    btn.addEventListener("click", () => {
      const el = btn.closest(".carousel");
      if (!el) return;
      Carousel.getOrCreateInstance(el).prev();
    });
  });

  document.querySelectorAll(".carousel .carousel-control-next").forEach((btn) => {
    btn.addEventListener("click", () => {
      const el = btn.closest(".carousel");
      if (!el) return;
      Carousel.getOrCreateInstance(el).next();
    });
  });
});

// Scroll window to top after a Turbo FRAME loads.
// Applies to #main_content by default, and to any frame with data-scroll-top-on-load.
// Instant scroll-to-top for Turbo FRAME navigations
// Force top-level Turbo Drive visit for most links clicked inside #main_content,
// so you see NO scrolling (new page opens at top). Still allow explicit frame links.
if (!window.__forceTopLevelVisits) {
  document.addEventListener("turbo:click", (event) => {
    const link = event.target?.closest?.("a[href]");
    if (!link) return;

    // ignore modified clicks or special cases
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link.target && link.target !== "_self") return;
    if (link.hasAttribute("download")) return;
    if (link.getAttribute("rel") === "external") return;
    if (link.origin && link.origin !== location.origin) return;   // external
    if (link.dataset.turbo === "false") return;                   // let browser handle
    if (link.dataset.turboMethod) return;                         // non-GET methods
    if (link.dataset.turboFrame && link.dataset.turboFrame !== "_top") return; // explicit frame

    // if the click happened inside your big frame, upgrade to a full-page visit
    if (link.closest("turbo-frame#main_content")) {
      event.preventDefault();
      Turbo.visit(link.href); // full page load => starts at top, no scrolling
    }
  });

  window.__forceTopLevelVisits = true;
}
