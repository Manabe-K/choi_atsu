import "@hotwired/turbo-rails"
import "./controllers"
import "./menu_toggle"
import "./event_card_click"

import flatpickr from "flatpickr"
import "flatpickr/dist/themes/material_orange.css"
import { Japanese } from "flatpickr/dist/l10n/ja.js"

flatpickr.localize(Japanese)

document.addEventListener("turbo:load", () => {
  const now = new Date()
  const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000)

  const startInput = document.querySelector("#event_start_time")
  const endInput = document.querySelector("#event_end_time")
  const deadlineInput = document.querySelector("#event_deadline")

  let endPicker, deadlinePicker

  // flatpickrの共通設定（altInputは使わない）
  const baseOptions = {
    enableTime: true,
    altInput: false, // ✅ altInput無効化でStimulusの色変化を有効に
    dateFormat: "m月d日 H:i", // ✅ 表示フォーマットを整える
    time_24hr: true,
    locale: Japanese,
    onOpen(_, __, instance) {
      instance.input.dispatchEvent(new Event("focus", { bubbles: true }))
    },
    onClose(_, __, instance) {
      instance.input.dispatchEvent(new Event("blur", { bubbles: true }))
    }
  }

  // 開始時間
  if (startInput) {
    flatpickr(startInput, {
      ...baseOptions,
      minDate: oneHourLater,
      onChange(selectedDates) {
        if (selectedDates.length > 0) {
          const start = selectedDates[0]
          if (endPicker) endPicker.set("minDate", start)
          if (deadlinePicker) deadlinePicker.set("maxDate", start)
        }
      }
    })
  }

  // 終了時間
  if (endInput) {
    endPicker = flatpickr(endInput, {
      ...baseOptions
    })
  }

  // 締切時間
  if (deadlineInput) {
    deadlinePicker = flatpickr(deadlineInput, {
      ...baseOptions,
      minDate: oneHourLater
    })
  }
})