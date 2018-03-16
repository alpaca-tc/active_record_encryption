# frozen_string_literal: true

module ActiverecordEncryption
  class Cipher
    def encrypt(_value)
      raise NotImplementedError, 'not implemented yet'
    end

    def decrypt(_value)
      raise NotImplementedError, 'not implemented yet'
    end
  end
end
