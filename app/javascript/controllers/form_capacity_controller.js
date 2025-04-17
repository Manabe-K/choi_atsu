import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["capacityField", "capacityInput", "fallback", "capacityText"]

  connect() {
    const noLimitChecked = this.element.querySelector("#event_no_limit")?.checked
    this.updateUI(noLimitChecked)
  }

  toggle(event) {
    const isNoLimit = event.target.value === "true"
    this.updateUI(isNoLimit)
  }

  updateUI(isNoLimit) {
    if (isNoLimit) {
      // 入力欄を無効化・薄くする
      this.capacityInputTarget.value = ""
      this.capacityInputTarget.disabled = true
      this.capacityFieldTarget.classList.add("opacity-50", "pointer-events-none")

      // fallback（999）は送信有効に
      this.fallbackTarget.disabled = false

      // 表示の切り替え（上限なしテキスト）
      this.capacityTextTarget?.classList.remove("hidden")
    } else {
      this.capacityInputTarget.disabled = false
      this.capacityFieldTarget.classList.remove("opacity-50", "pointer-events-none")
      this.fallbackTarget.disabled = true
      this.capacityTextTarget?.classList.add("hidden")
    }
  }
}