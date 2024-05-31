# frozen_string_literal: true

require "transmutation"
require "jbuilder"
require "representable"
require "active_model_serializers"
require "fast_jsonapi"
require "rabl"
require_relative "transmutation_benchmark/version"
require_relative "models/user"
require_relative "transmutation/user_serializer"
require_relative "representable/user_representer"
require_relative "active_model_serializers/user_serializer"
require_relative "fast_jsonapi/user_serializer"

module TransmutationBenchmark
  class Error < StandardError; end
  # Your code goes here...
end
