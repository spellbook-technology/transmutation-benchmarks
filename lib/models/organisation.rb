# frozen_string_literal: true

class Organisation < Base
  attr_accessor :id, :name

  def all
    @all ||= [
      Organisation.new(id: 1, name: 'Organisation 1'),
    ]
  end
end
