import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'cardElement', 'cardErrors', 'paymentMethodID' ]

  async connect() {
    if (typeof Stripe === 'undefined') {
      await this.loadStripeJS()
    }

    this.stripe = Stripe('pk_test_51R8nuNQTFhmFqSadewXvu7l2ltTWDjZwVTpv6qy5DATyiGefDpy5f3u17JhTlssXAyWs1EEdLjYPsSkjjcJHRfUV00yQl0pLpK')
    const elements = this.stripe.elements()

    this.card = elements.create('card')
    this.card.mount(this.cardElementTarget)

    this.card.on('change', (event) => {
      if (event.error) {
        this.cardErrorsTarget.textContent = event.error.message
      } else {
        this.cardErrorsTarget.textContent = ''
      }
    });
  }

  async submit(event) {
    event.preventDefault()

    const { error, paymentMethod } = await this.stripe.createPaymentMethod({
      type: 'card',
      card: this.card
    });

    if (error) {
      this.cardErrorsTarget.textContent = error.message
    } else {
      this.paymentMethodIDTarget.value = paymentMethod.id
      this.element.submit()
    }
  }

  loadStripeJS() {
    return new Promise((resolve, reject) => {
      const script = document.createElement('script')
      script.src = 'https://js.stripe.com/v3/'
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }
}