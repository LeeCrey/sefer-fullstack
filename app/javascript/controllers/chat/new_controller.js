import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat--new"
export default class extends Controller {
  static targets = ["image", "form"]

  constructor(e) {
    super(e)
    // attributes
    this.form = null
    this.observer = null;
  }

  connect() {
    var body = document.body;
    this.observer = new ResizeObserver(this.callBack);
    this.form = document.getElementById("new_chat_form")

    if ("ResizeObserver" in window) {
      this.observer.observe(body)
    }
  }

  disconnect() {
    this.observer.disconnect()
  }

  onImageSelect(event) {
    this.showImage(event)
  }

  showImage(evt) {
    var files = evt.target.files
    if (files.length === 0) {
      return
    }

    var reader = new FileReader()
    var img = this.imageTarget
    reader.onload = function (event) {
      img.src = event.target.result
    }
    reader.readAsDataURL(files[0])
  }

  onFormSubmit(event) {
    console.log(this.formTarget)
    var src = this.imageTarget.src
    var location = window.location.href
    if (src === location) {
      event.preventDefault()
    }
  }

  callBack() {
    const width = window.innerWidth

    console.log(this.form);
    if (width < 600) {
      // if (!this.btnTarget.hasAttribute("target")) {
      // this.btn.setAttribute("target", "_top")
      // }
    } else {
      // if (this.btnTarget.hasAttribute("target")) {
      // btn.removeAttribute("target")
      // }
    }
  }
}
