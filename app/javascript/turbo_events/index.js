Turbo.StreamActions.replace = function (element) {
  const original = Turbo.StreamActions.replace;
  original.apply(this, arguments);
  const event = new CustomEvent('turbo:after-stream-render', {
    detail: { element: this.targetElements }
  });
  document.dispatchEvent(event);
}

function dispatchTurboGeneralEvent() {
  document.dispatchEvent(new CustomEvent('turbo:general-load', {
    detail: { element: this.targetElements }
  }));
}

document.addEventListener("turbo:load", dispatchTurboGeneralEvent);

document.addEventListener('turbo:frame-load', dispatchTurboGeneralEvent);

document.addEventListener("turbo:after-stream-render", dispatchTurboGeneralEvent);