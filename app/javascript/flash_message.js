export function setupFlashMessageAutoDismiss() {
  console.log("🔥 setupFlashMessageAutoDismiss called");

  document.querySelectorAll(".flash-message").forEach((flash) => {
    if (flash.dataset.dismissScheduled === "true") return;
    flash.dataset.dismissScheduled = "true";

    setTimeout(() => {
      flash.classList.remove("opacity-100");
      flash.classList.add("opacity-0");

      setTimeout(() => {
        flash.remove();
      }, 800);
    }, 2000);
  });
}