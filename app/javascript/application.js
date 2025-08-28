import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import { Carousel } from "bootstrap"
import defaultRestaurant from "images/default-restaurant.png"


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
