# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    begin
      event = StripeManager::Webhook.build_event(request)
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    StripeManager::Webhook.route_event(event)

    render json: { status: 'success' }, status: :ok
  end
end
