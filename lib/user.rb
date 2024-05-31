# frozen_string_literal: true

class User # rubocop:disable Style/Documentation
  attr_accessor :id, :first_name, :last_name

  def initialize(id:, first_name:, last_name:)
    @id = id
    @first_name = first_name
    @last_name = last_name
  end

  def read_attribute_for_serialization(attribute)
    send(attribute)
  end
end
