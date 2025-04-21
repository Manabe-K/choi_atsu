import { Controller } from "@hotwired/stimulus"
import React from "react"
import { createRoot } from "react-dom/client"
import EventTagInput from "../components/EventTagInput"

export default class extends Controller {
  connect() {
    const props = JSON.parse(this.element.dataset.props)
    this.root = createRoot(this.element)
    this.root.render(<EventTagInput {...props} />)
  }

  disconnect() {
    this.root?.unmount()
  }
}