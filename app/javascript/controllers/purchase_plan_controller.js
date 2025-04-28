import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["plan", "price", "card", "submitButton"];

  change() {
    const planSelected = this.element.querySelector('input[name="price_id"]:checked');
    const paymentMethodSelected = this.element.querySelector('input[name="payment_method_id"]:checked');

    this.submitButtonTarget.disabled = !(planSelected && paymentMethodSelected);
  }

  changePlan(event) {
    const { plan, price } = event.target.dataset;
    if (plan && price) {
      this.planTarget.textContent = `${plan} Plan`;
      this.priceTarget.textContent = `${price} / month`;
    }
  }

  changeCard(event) {
    const { card } = event.target.dataset;
    if (card) {
      this.cardTarget.textContent = `Card Ending in ${card}`;
    }
  }
}