export const STRIPE_PUBLISHABLE_KEY = 'pk_test_51R8nuNQTFhmFqSadewXvu7l2ltTWDjZwVTpv6qy5DATyiGefDpy5f3u17JhTlssXAyWs1EEdLjYPsSkjjcJHRfUV00yQl0pLpK';

export async function loadStripe() {
  if (typeof Stripe === 'undefined') {
    await loadStripeScript();
  }
}

export function getCSRFToken() {
  const meta = document.querySelector('meta[name="csrf-token"]');
  return meta ? meta.getAttribute('content') : null;
}

function loadStripeScript() {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.src = 'https://js.stripe.com/v3/'
    script.onload = resolve;
    script.onerror = reject;
    document.head.appendChild(script);
  });
}