# frozen_string_literal: true

# Provides `json` RSpec helper for parsing JSON response body.
module JsonHelper
  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end
end
