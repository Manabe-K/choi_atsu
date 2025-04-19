import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja.js"

export default class extends Controller {
  connect() {
    if (!this.fp) {
      this.fp = flatpickr(this.element, {
        enableTime: true,
        altInput: false,
        dateFormat: "m月d日 H:i",
        time_24hr: true,
        locale: Japanese,
        onOpen: (_, __, instance) => {
          instance.input.dispatchEvent(new Event("focus", { bubbles: true }))
        },
        onClose: (_, __, instance) => {
          instance.input.dispatchEvent(new Event("blur", { bubbles: true }))
        }
      })
    }
  }
}