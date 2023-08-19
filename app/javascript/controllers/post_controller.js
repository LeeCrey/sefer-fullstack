import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="post"
export default class extends Controller {
  static targets = ["form", "count", "imageUrl", "content"];
  connect() { }

  onInputChange(event) {
    var len = event.target.value.length;
    this.countTarget.innerText = `${len}/1000`;
  }

  onSubmit(event) {
    var len = this.contentTarget.length
    if (len > 100) {
      event.preventDefault();
    }
  }
}
