import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.updateAll()
  }

  updateAll() {
    this.inputTargets.forEach(input => this.updateInput(input))
  }

  updateInput(input) {
    const value = input.value?.trim()
    if (value && value.length > 0) {
      input.classList.add("bg-blue-50")
    } else {
      input.classList.remove("bg-blue-50")
    }
  }

  handleInput(event) {
    this.updateInput(event.target)
  }
}