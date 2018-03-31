# frozen_string_literal: true

require 'active_record_encryption/testing/test_cipher'

Module.new do
  def build_cipher
    ActiveRecordEncryption::Testing::TestCipher.new
  end

  RSpec.configuration.include(self)
end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecordEncryption.with_cipher(build_cipher) do
      example.run
    end
  end
end
