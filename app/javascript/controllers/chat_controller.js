import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chat"
export default class extends Controller {
  static values = { id: Number };
  connect() {}

  open(_event) {
    window.location = `/chats/${this.idValue}`;
  }

  newChat(_event) {
    window.location = `/chats/new`;
  }
}
