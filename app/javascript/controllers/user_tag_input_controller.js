import { Controller } from "@hotwired/stimulus"
import React from "react"
import ReactDOM from "react-dom/client"
import UserTagInput from "../components/UserTagInput"

export default class extends Controller {
  connect() {
    const props = JSON.parse(this.element.dataset.props || "{}")
    this.root = ReactDOM.createRoot(this.element)
    this.root.render(<UserTagInput {...props} />)
  }

  disconnect() {
    this.root?.unmount()
  }
}
