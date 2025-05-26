import "@hotwired/turbo-rails"
import "./controllers"
import "./menu_toggle"
import "./event_card_click"
import { setupFlashMessageAutoDismiss } from "./flash_message"


// ✅ Turboページ遷移時に各種初期化
document.addEventListener("turbo:load", () => {
  setupFlashMessageAutoDismiss()
  window.bindEventCardClicks && window.bindEventCardClicks()

  // プロフィールメニューのトグル
  const profileButton = document.getElementById('profile-button')
  const dropdownMenu = document.getElementById('dropdown-menu')

  if (profileButton && dropdownMenu) {
    profileButton.addEventListener('click', function () {
      dropdownMenu.classList.toggle('hidden')
    })

    document.addEventListener('click', function (event) {
      if (!profileButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
        dropdownMenu.classList.add('hidden')
      }
    })
  }
})

// ✅ Turbo Streams 経由で flash が置き換わった直後に再実行
document.addEventListener("turbo:after-stream-render", (e) => {
  if (e.target?.id === "flash-area" || e.target?.closest("#flash-area")) {
    setupFlashMessageAutoDismiss()
  }
})
// ✅ 明示的に Turbo Stream script から使いたいときのために window に公開
window.setupFlashMessageAutoDismiss = setupFlashMessageAutoDismiss
