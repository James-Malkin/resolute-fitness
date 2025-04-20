import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'title', 'frame', 'titleValue' ]

  connect() {
    document.addEventListener('turbo:frame-render', () => this.updateTitle())
    document.addEventListener('turbo:after-stream-render', () => this.updateTitle())
    this.element.addEventListener('el.modal.show', () => this.open())
    this.element.addEventListener("click", (event) => this.handleBackdropClick(event));
  }

  resetFrame() {
    this.frameTarget.innerHTML = ''
    this.frameTarget.src = ''
    this.titleTarget.innerText = ''
  }

  updateTitle() {
    if (this.hasTitleValueTarget) {
      this.titleTarget.innerText = this.titleValueTarget.dataset.title
    }
  }

  open() {
    this.element.setAttribute('aria-hidden', false)
    this.element.showModal()
  }

  close() {
    this.element.close()
    this.resetFrame();
  }

  handleBackdropClick(event) {
    if (event.target === this.element) {
      this.close();
    }
  }
}