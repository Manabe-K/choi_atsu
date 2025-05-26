import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 2000 },
    fade: { type: Number, default: 800 }
  }

  connect() {
    if (this.element.dataset.dismissScheduled === "true") return
    this.element.dataset.dismissScheduled = "true"

    setTimeout(() => {
      this.element.classList.remove("opacity-100")
      this.element.classList.add("opacity-0")

      setTimeout(() => {
        this.element.remove()
      }, this.fadeValue)
    }, this.delayValue)
  }
}