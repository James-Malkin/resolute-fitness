// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers";

import "@hotwired/turbo-rails";

import "turbo_events";

function dispatchElementToggleEvent(event) {
  const target = event.currentTarget.dataset.elTarget;
  const element = document.querySelector(target);
  element?.dispatchEvent(
    new CustomEvent("el.modal.show", { detail: { target } })
  );
}

document.addEventListener("turbo:general-load", () => {
  document.querySelectorAll('[data-el-toggle="modal"]').forEach((el) => {
    el.addEventListener("click", dispatchElementToggleEvent);
  });
});
