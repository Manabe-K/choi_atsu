import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["capacityField"]

  connect() {
    this.toggle()
  }

  toggle() {
    const noLimit = this.element.querySelector("#event_no_limit")?.checked

    if (noLimit) {
      this.capacityFieldTarget.classList.add("opacity-0", "pointer-events-none")
    } else {
      this.capacityFieldTarget.classList.remove("opacity-0", "pointer-events-none")
    }
  }
}