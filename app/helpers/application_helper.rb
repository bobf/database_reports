# frozen_string_literal: true

# Generic helper for app views.
module ApplicationHelper
  def submit_text
    { 'new' => 'Create', 'create' => 'Create', 'edit' => 'Update' }.fetch(action_name)
  end
end
