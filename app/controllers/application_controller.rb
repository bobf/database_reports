# frozen_string_literal: true

# Base controller for all application endpoints.
class ApplicationController < ActionController::Base
  before_action :authenticate_user! unless Rails.env.test?
end
