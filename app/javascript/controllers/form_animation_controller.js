import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.updateAll()
  }

  updateAll() {
    this.inputTargets.forEach(input => this.updateInput(input))
  }

  handleFocus(event) {
    const input = event.target
    input.classList.remove("bg-white", "bg-blue-50", "bg-yellow-50")
    input.classList.add("bg-yellow-50")
  }

  handleBlur(event) {
    this.updateInput(event.target)
  }

  handleInput(event) {
    this.updateInput(event.target)
  }

  updateInput(input) {
    const value = input.value?.trim()
    input.classList.remove("bg-white", "bg-blue-50", "bg-yellow-50")

    if (value && value.length > 0) {
      input.classList.add("bg-blue-50")
    } else {
      input.classList.add("bg-white")
    }
  }
}