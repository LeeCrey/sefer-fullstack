import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["themeBox"]

  connect() {
    var _theme = this.getCookie("theme")
    if (_theme === "dark") {
      try {
        this.makeDarkTheme();
      } catch (error) {}
    }
  }

  toggle(event) {
    if (event.target.checked) {
      this.makeDarkTheme();
    } else {
      this.makeLightTheme();
    }
  }

  makeDarkTheme() {
    document.documentElement.classList.add("dark");
    document.cookie = "theme=dark;SameSite=Lax";
    this.themeBoxTarget.checked = true;
  }

  makeLightTheme() {
    document.documentElement.classList.remove("dark");
    document.cookie = "theme=light;SameSite=Lax";
    this.themeBoxTarget.checked = false;
  }

  // from w3 school
  getCookie(cName) {
    let name = cName + "=";
    let decondedCookie = decodeURIComponent(document.cookie);
    let ca = decondedCookie.split(";");
    for (let i = 0; i < ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) === " ") {
       c = c.substring(1);
      }  
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
    }
  }
}
