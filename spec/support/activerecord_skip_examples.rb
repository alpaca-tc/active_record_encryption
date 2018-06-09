# frozen_string_literal: true

# a few of spec are can not run.
skip_examples = {
  'test_time_attributes_changes_with_time_zone' => 'user defined attribute. This test expected Time attribute instead of Binary attribute',
  'test_time_attributes_changes_without_time_zone_by_skip' => 'user defined attribute. This test expected Time attribute instead of Binary attribute',
  'test_time_attributes_changes_without_time_zone' => 'user defined attribute. This test expected Time attribute instead of Binary attribute',
  'test_nullable_datetime_not_marked_as_changed_if_new_value_is_blank' => 'inherit from base class instead of Topic',
  'test_association_assignment_changes_foreign_key' => 'Pirate has no association',
  'test_attribute_should_be_compared_with_type_cast' => 'default values are defined as `user provided` instead of `from database`',
  'test_changed_attributes_should_be_preserved_if_save_failure' => 'Pirate has no association',
  'test_datetime_attribute_can_be_updated_with_fractional_seconds' => 'reson: #subsecond_precision_supported is not supported',
  'partial insert' => 'default values are defined as `user provided` instead of `from database`',
  'saved_changes returns a hash of all the changes that occurred' => 'default values are defined as `user provided` instead of `from database`'
}

RSpec.configure do |config|
  config.before do |example|
    description = example.metadata[:description]
    reason = skip_examples[description]

    if reason
      example.metadata[:skip] = reason
      RSpec::Core::Pending.mark_pending!(example, example.skip)
    end
  end
end
