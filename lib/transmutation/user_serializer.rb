# frozen_string_literal: true

class UserSerializer < Transmutation::Serializer # rubocop:disable Style/Documentation
  attributes :id, :first_name

  attribute :full_name do
    "#{object.first_name} #{object.last_name}"
  end
end
