# frozen_string_literal: true

module Jsonapi
  class PostSerializer
    include JSONAPI::Serializer

    attributes :id, :title, :body

    has_one :user
  end
end
