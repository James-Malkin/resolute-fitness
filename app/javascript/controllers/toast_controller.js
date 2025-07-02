import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toast"];

  connect() {
    if (!this.hasToastTarget) return;

    // this.toastTargets.forEach((toast) => {
    //   setTimeout(() => this.animateAndRemove(toast), 5000);
    // });
  }

  remove(event) {
    this.animateAndRemove(event.currentTarget);
  }

  animateAndRemove(element) {
    if (!element) return;

    element.classList.add('toast-removing');
    
    element.addEventListener('transitionend', () => {
      if (element && element.parentNode) {
        element.remove();
      }
    }, { once: true });
  }
}