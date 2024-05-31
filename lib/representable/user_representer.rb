# frozen_string_literal: true

class UserRepresenter < Representable::Decorator # rubocop:disable Style/Documentation
  include Representable::JSON

  property :id
  property :first_name
  property :full_name, getter: ->(represented:, **) { "#{represented.first_name} #{represented.last_name}" }
end
