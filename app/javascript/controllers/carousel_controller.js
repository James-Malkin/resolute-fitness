import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['card', 'indicators']

  static values = {
    active: { type: Number, default: 0 },
    intervalTime: { type: Number, default: 5000 },
    transitionDuration: { type: Number, default: 300 }
  }

  connect() {
    if (!this.hasCardTarget || !this.hasIndicatorsTarget) return
    this.setupCarousel()
  }

  setupCarousel() {
    this.initialiseIndicators()
    this.showActiveTarget()
    this.startAutoSlide()
  }

  next() {
    this.goToIndex((this.activeValue + 1) % this.cardTargets.length)
  }

  previous() {
    this.goToIndex((this.activeValue - 1 + this.cardTargets.length) % this.cardTargets.length)
  }

  goTo(index) {
    if (index === this.activeValue) return
    
    this.goToIndex(index)
    this.resetAutoSlide()
  }

  goToIndex(index) {
    const isMovingForward = index > this.activeValue || 
      (index === 0 && this.activeValue === this.cardTargets.length - 1)
    
    const currentIndex = this.activeValue
    const nextIndex = index
    
    this.animateTransition(currentIndex, nextIndex, isMovingForward)
  }

  animateTransition(currentIndex, nextIndex, isMovingForward) {
    const entryDirection = isMovingForward ? 'left' : 'right'
    const exitDirection = isMovingForward ? 'right' : 'left'
    
    const currentCard = this.cardTargets[currentIndex]
    const nextCard = this.cardTargets[nextIndex]
    
    nextCard.dataset.state = `entering-${entryDirection}`
    currentCard.dataset.state = `exiting-${exitDirection}`

    void nextCard.offsetHeight

    requestAnimationFrame(() => {
      nextCard.dataset.state = 'active'
      
      setTimeout(() => {
        currentCard.dataset.state = 'inactive'
        this.activeValue = nextIndex
        this.updateIndicators()
      }, this.transitionDurationValue)
    })
  }

  initialiseIndicators() {
    this.indicatorsTarget.innerHTML = ''
    
    this.cardTargets.forEach((_, index) => {
      const indicator = document.createElement('div')
      indicator.classList.add('carousel-indicator')
      indicator.dataset.index = index
      indicator.addEventListener('click', () => this.goTo(index))
      this.indicatorsTarget.appendChild(indicator)
    })

    this.updateIndicators()
  }

  showActiveTarget() {
    this.cardTargets.forEach((card, index) => {
      card.dataset.state = index === this.activeValue ? 'active' : 'inactive'
      card.dataset.index = index
    })
  }

  updateIndicators() {
    const indicators = this.indicatorsTarget.querySelectorAll('div')
    indicators.forEach((indicator, index) => {
      indicator.dataset.active = (index === this.activeValue).toString()
    })
  }

  resetAutoSlide() {
    this.stopAutoSlide()
    this.startAutoSlide()
  }

  stopAutoSlide() {
    if (this.intervalId) {
      clearInterval(this.intervalId)
      this.intervalId = null
    }
  }

  startAutoSlide() {
    this.stopAutoSlide()
    
    this.intervalId = setInterval(() => {
      this.next()
    }, this.intervalTimeValue)
  }

  disconnect() {
    this.stopAutoSlide()
  }
}