import "@hotwired/turbo-rails"
import "./controllers"
import "./menu_toggle"
import "./event_card_click"

import flatpickr from "flatpickr"
import "flatpickr/dist/themes/material_orange.css" // 🍊テーマ
import { Japanese } from "flatpickr/dist/l10n/ja.js" // 🇯🇵日本語ロケール追加

flatpickr.localize(Japanese) // グローバルで日本語化

document.addEventListener("turbo:load", () => {
  // ▼ メニュー開閉
  const profileButton = document.getElementById("profile-button")
  const dropdownMenu = document.getElementById("dropdown-menu")

  if (profileButton && dropdownMenu) {
    profileButton.addEventListener("click", () => {
      dropdownMenu.classList.toggle("hidden")
    })

    document.addEventListener("click", (event) => {
      if (!profileButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
        dropdownMenu.classList.add("hidden")
      }
    })
  }

  // ▼ flatpickr 初期化
  const startInput = document.querySelector("#event_start_time")
  const endInput = document.querySelector("#event_end_time")
  const deadlineInput = document.querySelector("#event_deadline")

  const now = new Date()
  const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000)

  let endPicker
  let deadlinePicker

  if (startInput) {
    const startPicker = flatpickr(startInput, {
      enableTime: true,
      dateFormat: "m月d日 H:i",
      time_24hr: true,
      minDate: oneHourLater,
      locale: Japanese,
      onChange: function (selectedDates) {
        if (selectedDates.length > 0) {
          const startDate = selectedDates[0]
          if (endPicker) endPicker.set("minDate", startDate)
          if (deadlinePicker) deadlinePicker.set("maxDate", startDate)
        }
      },
    })

    if (endInput) {
      endPicker = flatpickr(endInput, {
        enableTime: true,
        dateFormat: "m月d日 H:i",
        time_24hr: true,
        locale: Japanese,
      })
    }

    if (deadlineInput) {
      deadlinePicker = flatpickr(deadlineInput, {
        enableTime: true,
        dateFormat: "m月d日 H:i",
        time_24hr: true,
        minDate: oneHourLater,
        locale: Japanese,
      })
    }
  }
})