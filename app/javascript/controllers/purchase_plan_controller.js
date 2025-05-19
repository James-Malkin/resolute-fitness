import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["plan", "price", "card", "submitButton", 'description', 'title', 'featuresTable', 'planData', 'planName'];

  readOnly = false;
  plans = null;

  connect() {
    this.readOnly = !this.hasSubmitButtonTarget;
    this.plans = JSON.parse(this.planDataTarget.dataset.plans);
  }

  changePlan() {
    const planSelected = this.element.querySelector('input[name="price_id"]:checked');
    if (!planSelected) return;

    const planID = planSelected.value;

    const planData = this.plans.find(plan => plan.id === planID);

    if (!planData) return;

    const capitalizedPlan = planID.charAt(0).toUpperCase() + planID.slice(1);

    this.titleTarget.textContent = `The ${capitalizedPlan} Plan Includes:`;
    this.descriptionTarget.textContent = planData.description;
    
    this.updateFeatureHighlight(planData.id);

    if (!this.readOnly) {
      this.planNameTarget.textContent = `${capitalizedPlan} Plan`;
      this.priceTarget.textContent = `${planData.price} / month`;

      this.planTarget.value = planData.id;

      this.checkSubmitButton();
    }
  }

  changeCard(event) {
    const { card } = event.target.dataset;
    if (card) {
      this.cardTarget.textContent = `Card Ending in ${card}`;
    }

    this.checkSubmitButton();
  }

  updateFeatureHighlight(planID) {
    this.featuresTableTarget.dataset.selectedPlan = planID;

    this.featuresTableTarget.querySelectorAll('td.selected').forEach(cell => {
      cell.classList.remove('selected');
    });

    this.featuresTableTarget.querySelectorAll(`#plan_${planID}`).forEach(feature => {
      feature.classList.add('selected');
    });
  }

  checkSubmitButton() {
    if (this.readOnly) return;

    const planSelected = this.element.querySelector('input[name="price_id"]:checked');
    const paymentMethodSelected = this.element.querySelector('input[name="payment_method_id"]:checked');


    this.submitButtonTarget.disabled = !(planSelected && paymentMethodSelected);
  }
}