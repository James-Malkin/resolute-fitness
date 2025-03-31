import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "mobileMenu", "profileMenu" ]

  mql = window.matchMedia("(min-width: 768px)")


  connect() {
    this.mql.addEventListener("change", (e) => {e.matches && this.close()})

    this.element.addEventListener("click", (event) => {
      if (event.target === this.element && this.element.classList.contains("open")) {
        this.close()
      }
    })
  }

  open(event) {
    const targetMenu = event.currentTarget.dataset.target

    this.element.classList.add("open")
    this.element.dataset.target = targetMenu

    document.body.classList.toggle("overflow-hidden", true)

    this.targets.find(targetMenu).setAttribute("aria-expanded", true)
  }

  close() {
    this.element.classList.remove("open")

    document.body.classList.remove("overflow-hidden")

    this.mobileMenuTarget.setAttribute("aria-expanded", false)
    this.profileMenuTarget.setAttribute("aria-expanded", this.profileMenuTarget.classList.contains("open"))
  }
}