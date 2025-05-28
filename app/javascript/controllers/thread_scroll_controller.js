import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  scrollToBottom() {
    const el = this.containerTarget
    if (el) el.scrollTop = el.scrollHeight
  }
}