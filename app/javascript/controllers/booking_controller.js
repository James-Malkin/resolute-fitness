import { Controller } from "@hotwired/stimulus"
import { STRIPE_PUBLISHABLE_KEY, loadStripe, getCSRFToken } from "stripe_helpers"

export default class extends Controller {
  static targets = ["bookingID", "paymentElement", "errorMessage", "submitButton", "paymentContainer"]

  async connect() {
    await loadStripe()

    this.stripe = Stripe(STRIPE_PUBLISHABLE_KEY)

    this.setupPaymentForm()
  }
  
  async setupPaymentForm() {
    const bookingID = this.bookingIDTarget.value
    
    try {
      const response = await fetch('/stripe/payments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': getCSRFToken()
        },
        body: JSON.stringify({ booking_id: bookingID })
      })
      
      if (!response.ok) throw new Error('Failed to create payment intent')
      
      const { client_secret, payment_intent_id } = await response.json()
      this.paymentIntentId = payment_intent_id
      
      const elements = this.stripe.elements({ clientSecret: client_secret })
      this.paymentElement = elements.create('payment')
      this.paymentElement.mount(this.paymentElementTarget)
      this.elements = elements
      
    } catch (error) {
      this.showError(error.message)
    }
  }
  
  async handleSubmit(event) {
    event.preventDefault()
    
    this.submitButtonTarget.disabled = true
    
    try {
      const { error } = await this.stripe.confirmPayment({
        elements: this.elements,
        confirmParams: {
          return_url: `${window.location.origin}/bookings/${this.bookingIDTarget.value}`,
        }
      })
      
      if (error) throw error
      
    } catch (error) {
      this.submitButtonTarget.disabled = false
    }
  }
  
  showError(message) {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = message
      this.errorMessageTarget.classList.remove('hidden')
    } else {
      console.error(message)
    }
  }
}