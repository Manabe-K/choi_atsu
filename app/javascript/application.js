import "@hotwired/turbo-rails"
import "./controllers"
import "./menu_toggle"
import "./event_card_click"

import flatpickr from "flatpickr"
import "flatpickr/dist/themes/material_orange.css"
import { Japanese } from "flatpickr/dist/l10n/ja.js"

import React from "react"
import ReactDOM from "react-dom/client"
import FormUserSearch from "./components/FormUserSearch"

flatpickr.localize(Japanese)

function initializeFlatpickr() {
  const now = new Date()
  const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000)

  const startInput = document.querySelector("#event_start_time")
  const endInput = document.querySelector("#event_end_time")
  const deadlineInput = document.querySelector("#event_deadline")

  let endPicker, deadlinePicker

  const baseOptions = {
    enableTime: true,
    altInput: false,
    dateFormat: "m月d日 H:i",
    time_24hr: true,
    locale: Japanese,
    onOpen(_, __, instance) {
      instance.input.dispatchEvent(new Event("focus", { bubbles: true }))
    },
    onClose(_, __, instance) {
      instance.input.dispatchEvent(new Event("blur", { bubbles: true }))
    }
  }

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

  if (endInput) {
    endPicker = flatpickr(endInput, {
      ...baseOptions
    })
  }

  if (deadlineInput) {
    deadlinePicker = flatpickr(deadlineInput, {
      ...baseOptions,
      minDate: oneHourLater
    })
  }
}

// ✅ Turboページ遷移時に各種初期化
document.addEventListener("turbo:load", () => {
  initializeFlatpickr()

  // イベントカードクリック再バインド
  window.bindEventCardClicks && window.bindEventCardClicks()

  // プロフィールメニューのトグル
  const profileButton = document.getElementById('profile-button')
  const dropdownMenu = document.getElementById('dropdown-menu')

  if (profileButton && dropdownMenu) {
    profileButton.addEventListener('click', function () {
      dropdownMenu.classList.toggle('hidden')
    })

    document.addEventListener('click', function (event) {
      if (!profileButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
        dropdownMenu.classList.add('hidden')
      }
    })
  }
})

