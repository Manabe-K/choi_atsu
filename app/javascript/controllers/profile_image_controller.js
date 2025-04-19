import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "removeFlag", "removeButton", "profilePictureUrl"]

  connect() {
    this.originalSrc = this.previewTarget.src
    const raw = this.profilePictureUrlTarget?.value || this.originalSrc
    this.fallbackSrc = raw.startsWith("demo_image_")
      ? `/demo_images/${raw}`
      : raw
  }

  previewImage(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.removeFlagTarget.value = "false"
      if (this.hasRemoveButtonTarget) {
        this.removeButtonTarget.classList.remove("hidden")
      }
    }
    reader.readAsDataURL(file)
  }

  clearImage() {
    this.removeFlagTarget.value = "true"

    const input = this.element.querySelector("input[type='file']")
    if (input) input.value = ""

    // 👇 fallback（GitHub URLやデモ画像）に戻す
    this.previewTarget.src = this.fallbackSrc

    if (this.hasRemoveButtonTarget) {
      this.removeButtonTarget.classList.add("hidden")
    }
  }
}