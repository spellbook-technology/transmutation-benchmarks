# frozen_string_literal: true

class UserFastSerializer # rubocop:disable Style/Documentation
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name

  attribute :full_name do |object|
    "#{object.first_name} #{object.last_name}"
  end
end
