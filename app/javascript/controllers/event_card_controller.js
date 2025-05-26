import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.handleClickBound = this.handleClick.bind(this)
    this.element.addEventListener("click", this.handleClickBound)
  }

  disconnect() {
    this.element.removeEventListener("click", this.handleClickBound)
  }

  handleClick(e) {
    if (e.target.closest("a, button")) return
    if (this.urlValue) window.location.href = this.urlValue
  }
}