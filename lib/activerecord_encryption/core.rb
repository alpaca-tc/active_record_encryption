# frozen_string_literal: true

module ActiverecordEncryption
  module Core
    extend ActiveSupport::Concern

    included do
      include EncryptedAttributes
    end
  end
end
