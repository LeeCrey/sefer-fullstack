import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["first_name", "last_name"];
  connect() {}

  submit(event) {
    const fName = this.first_nameTarget.value;
    const lName = this.last_nameTarget.value;
    if (fName === "" && (lName === lName) === "") {
      event.preventDefault();
    } else {
      //
    }
  }
}
