import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['card', 'indicators']

  static values = {
    active: { type: Number, default: 0 },
    intervalTime: { type: Number, default: 5000 }
  }

  intervalId = null

  connect() {
    this.setupCarousel();
  }

  setupCarousel() {
    this.initialiseIndicators();
    this.showActiveTarget();
    this.startAutoSlide();
  }
  
  next() {
    this.cardTargets[this.activeValue].classList.remove('active')
    this.activeValue = (this.activeValue + 1) % this.cardTargets.length
    this.showActiveTarget()
  }

  goTo(index) {
    if (index !== this.activeValue) {
      this.cardTargets[this.activeValue].classList.remove('active')
      this.activeValue = index
      this.showActiveTarget()
    }
    this.startAutoSlide();
  }
  
  initialiseIndicators() {
    for (let i = 0; i < this.cardTargets.length; i++) {
      const indicator = document.createElement('div')
      indicator.dataset.index = i
      indicator.addEventListener('click', () => this.goTo(i))
      this.indicatorsTarget.appendChild(indicator)
    }
  }
  
  showActiveTarget() {
    this.cardTargets[this.activeValue].classList.add('active')
    this.updateIndicators();
  }

  updateIndicators() {
    const indicators = this.indicatorsTarget.querySelectorAll('div');
    indicators.forEach((indicator, index) => {
      indicator.dataset.active = (index === this.activeValue).toString();
    });
  }
  
  startAutoSlide() {
    if (this.intervalId) {
      clearInterval(this.intervalId)
      this.intervalId = null
    }

    this.intervalId = setInterval(() => {
      this.next();
    }, this.intervalTimeValue);
  }

  disconnect() {
    clearInterval(this.intervalId);
  }
}