# frozen_string_literal: true

module ActiveRecordEncryption
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
    if ActiveRecord.gem_version < Gem::Version.create('6.0')
      # https://github.com/rails/rails/commit/a741208f80dd33420a56486bd9ed2b0b9862234a
      refine ActiveModel::Type::Decimal do
        def serialize(value)
          cast(value)
        end
      end

      # https://github.com/rails/rails/commit/34cc301f03aea2e579d6687a9ea9782afc1089a0
      refine ActiveModel::Type::Boolean do
        def serialize(value)
          cast(value)
        end
      end
    end

    # Backport Rails5.2
    if ActiveRecord.gem_version < Gem::Version.create('5.2')
      refine ActiveModel::Type::DateTime do
        def serialize(value)
          super(cast(value))
        end
      end
    end
  end
end
