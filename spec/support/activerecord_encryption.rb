# frozen_string_literal: true

require 'activerecord_encryption/testing/test_cipher'

Module.new do
  def build_cipher
    ActiverecordEncryption::Cipher::Aes256cbc.new(
      key: OpenSSL::Cipher.new('AES-256-CBC').random_key,
      iv: OpenSSL::Random.random_bytes(16)
    )
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
