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

  function parseJapaneseDatetime(str) {
    const match = str.match(/(\d{1,2})月(\d{1,2})日\s+(\d{1,2}):(\d{2})/)
    if (!match) return null
    const [, month, day, hour, minute] = match.map(Number)
    const now = new Date()
    return new Date(now.getFullYear(), month - 1, day, hour, minute)
  }

  if (startInput) {
    const parsedStart = startInput.value ? parseJapaneseDatetime(startInput.value) : null
    const minStart = parsedStart && parsedStart < oneHourLater ? parsedStart : oneHourLater

    flatpickr(startInput, {
      ...baseOptions,
      minDate: minStart,
      defaultDate: parsedStart,
      onChange(selectedDates) {
        const start = selectedDates[0]
        if (endPicker) endPicker.set("minDate", start)
        if (deadlinePicker) deadlinePicker.set("maxDate", start)
      }
    })
  }

  if (endInput) {
    const parsedEnd = endInput.value ? parseJapaneseDatetime(endInput.value) : null
    endPicker = flatpickr(endInput, {
      ...baseOptions,
      defaultDate: parsedEnd
    })
  }

  if (deadlineInput) {
    const parsedDeadline = deadlineInput.value ? parseJapaneseDatetime(deadlineInput.value) : null
    const parsedStart = startInput.value ? parseJapaneseDatetime(startInput.value) : null

    deadlinePicker = flatpickr(deadlineInput, {
      ...baseOptions,
      defaultDate: parsedDeadline,
      minDate: parsedDeadline && parsedDeadline < oneHourLater ? parsedDeadline : oneHourLater,
      maxDate: parsedStart || null
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

