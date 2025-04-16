document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".event-card").forEach(function (card) {
    card.addEventListener("click", function (e) {
      // aタグやボタンがクリックされたときは無視
      if (e.target.closest("a") || e.target.closest("button")) return;

      const url = card.dataset.url;
      if (url) {
        window.location.href = url;
      }
    });
  });
});