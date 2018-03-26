# frozen_string_literal: true

Module.new do
  def build_cipher
    ActiverecordEncryption::Cipher::Aes256cbc.new(
      password: OpenSSL::Random.random_bytes(8),
      salt: OpenSSL::Random.random_bytes(8)
    )
  end

  RSpec.configuration.include(self)
end

RSpec.configure do |config|
  config.around do |example|
    ActiverecordEncryption.cipher = nil
    example.run
  end
end
