import { Controller } from "@hotwired/stimulus"
import { STRIPE_PUBLISHABLE_KEY, loadStripe } from "stripe_helpers"

export default class extends Controller {
  static targets = [ 'cardElement', 'cardErrors', 'paymentMethodID' ]

  async connect() {
    await loadStripe()

    this.stripe = Stripe(STRIPE_PUBLISHABLE_KEY)
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
}