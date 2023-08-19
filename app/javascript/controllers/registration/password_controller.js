import ApplicationController from "../application_controller";

// Connects to data-controller="registration--password"
export default class Password extends ApplicationController {
  static targets = ["password", "status", "btn"];

  connect() {
    super.connect();
  }

  togglePassword(event) {
    var pwd = this.passwordTarget;
    if (pwd.getAttribute("type") === "text") {
      pwd.setAttribute("type", "password");
    } else {
      pwd.setAttribute("type", "text");
    }
    event.target.classList.toggle("bx-show");
    event.target.classList.toggle("bx-hide");
  }

  checkPasswordConfirmation(event) {
    var cpwd = event.target.value;
    var pwd = this.passwordTarget.value;
    if (cpwd === "") {
      this.removeStatus();
    } else {
      if (cpwd === pwd) {
        this.showCorrect();
        this.btnTarget.classList.remove("disabled");
        this.btnTarget.classList.remove("hover:cursor-not-allowed");
      } else {
        this.showIncorrect();
        if (!this.btnTarget.classList.contains("disabled")) {
          this.btnTarget.classList.add("disabled");
          this.btnTarget.classList.add("hover:cursor-not-allowed");
        }
      }
    }
  }

  // ************* breaking down **************
  removeStatus() {
    this.statusTarget.classList.remove("correct");
    this.statusTarget.classList.remove("incorrect");
  }

  showCorrect() {
    this.statusTarget.classList.add("correct");
    this.statusTarget.classList.remove("incorrect");
  }

  showIncorrect() {
    this.statusTarget.classList.remove("correct"); // dont worry
    if (!this.statusTarget.classList.contains("incorrect")) {
      this.statusTarget.classList.add("incorrect");
    }
  }
}
