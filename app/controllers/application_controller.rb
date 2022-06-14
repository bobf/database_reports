# frozen_string_literal: true

# Base controller for all application endpoints.
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authorize_admin
    return if current_user&.admin?

    render template: 'shared/not_authorized', status: :forbidden
  end
end
