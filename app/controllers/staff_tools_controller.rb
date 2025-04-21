# frozen_string_literal: true

class StaffToolsController < ApplicationController
  before_action :authorize_user!

  def index; end

  private

  def authorize_user!
    authorize! :access, :staff_tools
  end
end
