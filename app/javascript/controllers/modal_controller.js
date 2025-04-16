import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'title', 'frame', 'titleValue' ]

  connect() {
    document.addEventListener('turbo:frame-render', () => this.updateTitle())
    document.addEventListener('turbo:after-stream-render', () => this.updateTitle())
    this.element.addEventListener('el.modal.show', (event) => this.open(event))
    this.element.addEventListener("click", (event) => this.handleBackdropClick(event));
    document.addEventListener('turbo:frame-render', (e) => this.handleFrameRender(e))
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

  handleFrameRender(event) {
    console.log(event)
    if (event.target === this.frameTarget) {
      console.log('frame!!')
    }
  }

  open(event) {
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