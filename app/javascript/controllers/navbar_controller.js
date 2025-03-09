import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  mql = window.matchMedia("(min-width: 768px)")


  connect() {
  this.mql.addEventListener("change", (e) => {e.matches && this.close()})
  }

  toggle(event) {
    this.element.classList.toggle("open")

    document.body.classList.toggle("overflow-hidden", this.element.classList.contains("open"))
  
    const button = event.currentTarget
    button.setAttribute("aria-expanded", this.element.classList.contains("open"))
  }

  close() {
    this.element.classList.remove("open")
    document.body.classList.remove("overflow-hidden")
    this.menuTarget.setAttribute("aria-expanded", false)
  }
}