import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja.js"

flatpickr.localize(Japanese)

export default class extends Controller {
  static targets = ["start", "end"]

  connect() {
    const now = new Date()
    const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000)

    const baseOptions = {
      enableTime: true,
      altInput: false,
      dateFormat: "m月d日 H:i",
      time_24hr: true,
      locale: Japanese,
    }

    const parse = (str) => {
      const match = str?.match(/(\d{1,2})月(\d{1,2})日\s+(\d{1,2}):(\d{2})/)
      if (!match) return null
      const [, month, day, hour, minute] = match.map(Number)
      const now = new Date()
      return new Date(now.getFullYear(), month - 1, day, hour, minute)
    }

    const parsedStart = parse(this.startTarget.value)
    const parsedEnd = parse(this.endTarget.value)
    const minStart = parsedStart && parsedStart < oneHourLater ? parsedStart : oneHourLater

    this.endPicker = flatpickr(this.endTarget, {
      ...baseOptions,
      minDate: parsedStart ?? oneHourLater,
      defaultDate: parsedEnd
    })

    this.startPicker = flatpickr(this.startTarget, {
      ...baseOptions,
      minDate: minStart,
      defaultDate: parsedStart,
      onChange: ([start]) => {
        this.endPicker.set("minDate", start)
      }
    })
  }
}