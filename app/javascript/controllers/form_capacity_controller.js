import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["capacityField", "capacityInput", "fallback"]

  connect() {
    this.toggle()
  }

  toggle() {
    const noLimitChecked = this.element.querySelector("#event_no_limit")?.checked

    if (noLimitChecked) {
      // ✅ 入力を無効化し、値もクリア（数字を残さない）
      this.capacityInputTarget.value = ""
      this.capacityInputTarget.disabled = true
      this.capacityFieldTarget.classList.add("opacity-50", "pointer-events-none")
      this.fallbackTarget.disabled = false
    } else {
      this.capacityInputTarget.disabled = false
      this.capacityFieldTarget.classList.remove("opacity-50", "pointer-events-none")
      this.fallbackTarget.disabled = true
    }
  }
}