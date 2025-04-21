# frozen_string_literal: true

module Jsonapi
  class UserSerializer
    include JSONAPI::Serializer

    attributes :id, :first_name

    attribute :full_name do |object|
      "#{object.first_name} #{object.last_name}"
    end

    has_many :posts
  end
end
