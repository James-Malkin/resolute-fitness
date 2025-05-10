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
    this.transitionCard((this.activeValue + 1) % this.cardTargets.length)
  }

  transitionCard(nextActiveValue) {
    const entryDirection = 'left'
    const exitDirection = 'right'

    this.cardTargets[nextActiveValue].dataset.state = `entering-${entryDirection}`
    this.cardTargets[this.activeValue].dataset.state = `exiting-${exitDirection}`

    void this.cardTargets[nextActiveValue].offsetHeight;

    requestAnimationFrame(() => {
      this.cardTargets[nextActiveValue].dataset.state = 'active';
      
      setTimeout(() => {
        this.cardTargets[this.activeValue].dataset.state = 'inactive';
        this.activeValue = nextActiveValue;
        this.updateIndicators();
      }, 300);
    });
  }

  goTo(index) {
    if (index !== this.activeValue) { this.transitionCard(index) }
    this.startAutoSlide();
  }

  initialiseIndicators() {
    for (let i = 0; i < this.cardTargets.length; i++) {
      const indicator = document.createElement('div')
      indicator.dataset.index = i
      indicator.addEventListener('click', () => this.goTo(i))
      this.indicatorsTarget.appendChild(indicator)
    }

    this.updateIndicators();
  }

  showActiveTarget() {
    this.cardTargets.forEach((card, index) => {
      card.dataset.state = index === this.activeValue ? 'active' : 'inactive'
      card.dataset.index = index
    })
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