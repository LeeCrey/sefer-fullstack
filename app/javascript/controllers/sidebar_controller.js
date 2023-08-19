import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["side", "container", "sideMenu"]
  connect() {
  }

  toggle(_event) {
    this.containerTarget.classList.toggle("move-container")
    this.sideTarget.classList.toggle("open-side-bar")
  }

  toggleSideBar(_event) {
    this.containerTarget.classList.toggle("move-container")
    this.sideMenuTarget.classList.toggle("open-side-bar")
  }
}
