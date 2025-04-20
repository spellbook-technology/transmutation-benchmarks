# frozen_string_literal: true

module Representable
  class UserRepresenter < Representable::Decorator
    include Representable::JSON

    property :id
    property :first_name
    property :full_name, getter: ->(represented:, **) { "#{represented.first_name} #{represented.last_name}" }
  end
end
