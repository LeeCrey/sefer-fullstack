import { Controller } from "@hotwired/stimulus"

// chats page

// Connects to data-controller="chat--index"
export default class extends Controller {
  connect() {
    const received = (data) => this.received(data);
  }

  received(data) {

  }
}
