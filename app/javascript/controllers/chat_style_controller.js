// app/javascript/controllers/chat_style_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    userId: Number
  }

  static targets = ["wrapper", "bubble", "timeLeft", "timeRight"]

  connect() {
    const currentUserId = Number(document.body.dataset.currentUserId)

    if (this.userIdValue === currentUserId) {
      // 自分の投稿
      this.wrapperTarget.classList.remove("chat-start")
      this.wrapperTarget.classList.add("chat-end")

      this.bubbleTarget.classList.remove("bg-gray-100", "text-gray-800")
      this.bubbleTarget.classList.add("bg-green-200", "text-black")

      this.timeLeftTarget.style.display = "block"
      this.timeRightTarget.style.display = "none"
    } else {
      // 相手の投稿
      this.wrapperTarget.classList.remove("chat-end")
      this.wrapperTarget.classList.add("chat-start")

      this.bubbleTarget.classList.remove("bg-green-200", "text-black")
      this.bubbleTarget.classList.add("bg-gray-100", "text-gray-800")

      this.timeLeftTarget.style.display = "none"
      this.timeRightTarget.style.display = "block"
    }
  }
}