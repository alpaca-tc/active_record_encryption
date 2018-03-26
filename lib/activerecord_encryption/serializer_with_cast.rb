# frozen_string_literal: true

module ActiverecordEncryption
  module SerializerWithCast
    # Unfortunately, current Rails doesn't serialize value from user input with `#cast`.
    # IMO, it is expected that serialized value from user input should be equal same result.
    #
    # Example:
    #   # Current
    #   User.attribute(:id, :boolean)
    #   User.where(id: 'string').to_sql #=> SELECT `users`.* FROM `users` WHERE `users`.`id` = 'string'
    #   User.where(id: true).to_sql     #=> SELECT `users`.* FROM `users` WHERE `users`.`id` = TRUE
    #
    #   # Expected
    #   User.attribute(:id, :boolean)
    #   User.where(id: 'string').to_sql #=> SELECT `users`.* FROM `users` WHERE `users`.`id` = TRUE
    #   User.where(id: true).to_sql     #=> SELECT `users`.* FROM `users` WHERE `users`.`id` = TRUE
    refine ActiveModel::Type::Decimal do
      def serialize(value)
        cast(value)
      end
    end

    refine ActiveModel::Type::Boolean do
      def serialize(value)
        cast(value)
      end
    end
  end
end
