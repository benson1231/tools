document.addEventListener("DOMContentLoaded", function () {
  const overlay = document.getElementById("lightbox-overlay");
  const overlayImg = document.getElementById("lightbox-img");

  if (!overlay || !overlayImg) return;

  document.querySelectorAll("img.img-fluid").forEach(img => {
    img.addEventListener("click", () => {
      overlayImg.src = img.src;
      overlay.style.display = "flex";
    });
  });

  overlay.addEventListener("click", () => {
    overlay.style.display = "none";
    overlayImg.src = "";
  });

  document.addEventListener("keydown", e => {
    if (e.key === "Escape") {
      overlay.style.display = "none";
      overlayImg.src = "";
    }
  });
});
