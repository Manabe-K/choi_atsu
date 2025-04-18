window.bindEventCardClicks = function () {
  console.log("🎯 bindEventCardClicks 実行");

  document.querySelectorAll(".event-card").forEach((card) => {
    // いったん削除してから再バインド（保険）
    card.replaceWith(card.cloneNode(true));
  });

  document.querySelectorAll(".event-card").forEach((card) => {
    card.addEventListener("click", (e) => {
      if (e.target.closest("a") || e.target.closest("button")) return;
      const url = card.dataset.url;
      if (url) window.location.href = url;
    });
  });
};