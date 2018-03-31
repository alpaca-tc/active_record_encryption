# frozen_string_literal: true

require 'active_support/testing/time_helpers'

RSpec.configure do |config|
  config.after do
    travel_back
  end

  config.include ActiveSupport::Testing::TimeHelpers
end
