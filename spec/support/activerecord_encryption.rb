# frozen_string_literal: true

RSpec.configure do |config|
  config.around do |example|
    ActiverecordEncryption.cipher = nil
    example.run
  end
end
