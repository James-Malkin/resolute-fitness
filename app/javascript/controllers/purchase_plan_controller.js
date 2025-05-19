import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["plan", "price", "card", "submitButton", 'description', 'title', 'featuresTable', 'planData'];

  readOnly = false;
  plans = null;

  connect() {
    this.readOnly = !this.hasPurchaseFormTarget;
    this.plans = JSON.parse(this.planDataTarget.dataset.plans);

    console.log(this.plans);
  }

  change() {
    const planSelected = this.element.querySelector('input[name="price_id"]:checked');
    if (!planSelected) return;
    
    // Get the plan ID from the selected radio button
    const planId = planSelected.value;
    
    // Find the matching plan from the parsed data
    const selectedPlanData = this.plans.find(plan => plan.id === planId);
    
    // Update the table's selected plan attribute
    this.featuresTableTarget.dataset.selectedPlan = planId;
    
    // Remove selected class from all cells
    this.featuresTableTarget.querySelectorAll('td.selected').forEach(cell => {
      cell.classList.remove('selected');
    });
    
    // Then add 'selected' class to the features of the selected plan
    const featureData = this.featuresTableTarget.querySelectorAll(`#plan_${planId}`);
    featureData.forEach(feature => {
      feature.classList.add('selected');
    });

    // Capitalize the first letter of the plan ID
    const capitalizedPlan = planId.charAt(0).toUpperCase() + planId.slice(1);
    
    // Update title and description using the data from the JSON
    this.titleTarget.textContent = `The ${capitalizedPlan} Plan Includes:`;
    
    // Use the description from the JSON data
    this.descriptionTarget.textContent = selectedPlanData.description;

    // Handle payment method logic 
    const paymentMethodSelected = this.element.querySelector('input[name="payment_method_id"]:checked');
    
    if (!this.readOnly) {
      this.submitButtonTarget.disabled = !(planSelected && paymentMethodSelected);
    }
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