document.addEventListener("turbo:frame-load", () => {
  const flash = document.querySelector("#flash .alert");
  if (flash) {
    setTimeout(() => flash.remove(), 3000); // disappear after 3 seconds
  }
});
