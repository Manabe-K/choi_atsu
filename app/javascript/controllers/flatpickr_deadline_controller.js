import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Japanese } from "flatpickr/dist/l10n/ja.js"

flatpickr.localize(Japanese)

export default class extends Controller {
  static targets = ["deadline"]

  connect() {
    const baseOptions = {
      enableTime: true,
      altInput: false,
      dateFormat: "m月d日 H:i",
      time_24hr: true,
      locale: Japanese
    }

    const parse = (str) => {
      const match = str?.match(/(\d{1,2})月(\d{1,2})日\s+(\d{1,2}):(\d{2})/)
      if (!match) return null
      const [, month, day, hour, minute] = match.map(Number)
      const now = new Date()
      return new Date(now.getFullYear(), month - 1, day, hour, minute)
    }

    const now = new Date()
    const parsedDeadline = parse(this.deadlineTarget.value)

    // フォーム上のstart/endフィールドの値を取得
    const startInput = document.querySelector("#event_start_time")
    const endInput = document.querySelector("#event_end_time")
    const parsedStart = startInput ? parse(startInput.value) : null
    const parsedEnd = endInput ? parse(endInput.value) : null

    const minDate = parsedStart && parsedStart > now ? parsedStart : now
    const maxDate = parsedEnd || null

    flatpickr(this.deadlineTarget, {
      ...baseOptions,
      defaultDate: parsedDeadline,
      minDate: minDate,
      maxDate: maxDate
    })
  }
}