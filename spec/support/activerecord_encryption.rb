# frozen_string_literal: true

require 'activerecord_encryption/testing/test_cipher'

Module.new do
  def build_cipher
    ActiverecordEncryption::Testing::TestCipher.new
  end

  RSpec.configuration.include(self)
end

RSpec.configure do |config|
  config.around do |example|
    ActiverecordEncryption.with_cipher(build_cipher) do
      example.run
    end
  end
end
