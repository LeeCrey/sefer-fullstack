import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="application"
export default class ApplicationController extends Controller {

  connect() {
  }

  redirectBack(_event) {
    history.back();
  }
}
