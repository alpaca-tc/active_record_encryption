# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    class Registry < ActiveModel::Type::Registry
      private

      def registration_klass
        Registration
      end

      def find_registration(symbol, *args, **kwargs)
        registrations.find { |r| r.matches?(symbol, *args, **kwargs) }
      end
    end

    class Registration
      def initialize(name, block, **)
        @name = name
        @block = block
      end

      def call(_registry, *args, **kwargs)
        if kwargs.any? # https://bugs.ruby-lang.org/issues/10856
          block.call(*args, **kwargs)
        else
          block.call(*args)
        end
      end

      def matches?(encryptor_name, *_args, **_kwargs)
        encryptor_name == name
      end

      private

      attr_reader :name, :block
    end
  end
end
