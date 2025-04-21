# frozen_string_literal: true

module Jsonapi
  class OrganisationSerializer
    include JSONAPI::Serializer

    attributes :id, :name

    attribute :logo_url do |object|
      "https://example.com/logos/companies/#{object.id}"
    end
  end
end
