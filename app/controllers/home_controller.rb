# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    TestMailer.test_email.deliver_now
  end
end
