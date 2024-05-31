# frozen_string_literal: true

require "benchmark/ips"
require "benchmark-memory"
require "terminal-table"
require "active_support/core_ext/object/deep_dup" # Required by AMS

require "transmutation"
require "jbuilder"
require "representable"
require "active_model_serializers"
require "fast_jsonapi"
require "rabl"
require_relative "lib/benchie"
require_relative "lib/user"
require_relative "lib/transmutation/user_serializer"
require_relative "lib/representable/user_representer"
require_relative "lib/active_model_serializers/user_serializer"
require_relative "lib/fast_jsonapi/user_serializer"

require "multi_json" # Required by Representable
require "oj" # Required by Rabl
Oj.mimic_JSON # Use OJ for benchmarks using #to_json
MultiJson.use(:oj) # Use OJ by default from multi_json

user = User.new(id: 1, first_name: "John", last_name: "Doe")
jbuilder_template = File.read(File.expand_path("lib/jbuilder/user.json.jbuilder", __dir__))
rabl_template = File.read(File.expand_path("lib/rabl/user.json.rabl", __dir__))

Benchie.print_suite_banner
Benchie.start

Benchie.print_section_separator("Member tests")

Benchie.measure("Ultra Simple: Member") do |x|
  x.config(time: 10, warmup: 2)

  x.report(format("%-36.36s", "Transmutation #{Transmutation::VERSION}")) { UserSerializer.new(user).to_json }
  x.report(format("%-36.36s", "Jbuilder #{Gem.loaded_specs["jbuilder"].version}")) do
    Jbuilder.encode do |json|
      json.instance_eval(jbuilder_template)
      json.target!
    end
  end
  x.report(format("%-36.36s", "Representable #{Gem.loaded_specs["representable"].version}")) do
    UserRepresenter.new(user).to_json
  end
  x.report(format("%-36.36s", "AMS #{ActiveModel::Serializer::VERSION}")) do
    UserActiveSerializer.new(user).to_json
  end
  x.report(format("%-36.36s", "FastJsonapi #{Gem.loaded_specs["fast_jsonapi"].version}")) do
    UserFastSerializer.new(user).serialized_json
  end
  x.report(format("%-36.36s", "Rabl #{Rabl::VERSION}")) { Rabl::Renderer.json(user, rabl_template) }
end

Benchie.print_section_separator("Memory Usage")

Benchie.measure_memory("Ultra Simple: Member") do |x|
  x.report(format("%-36.36s", "Transmutation #{Transmutation::VERSION}")) { UserSerializer.new(user).to_json }
  x.report(format("%-36.36s", "Jbuilder #{Gem.loaded_specs["jbuilder"].version}")) do
    Jbuilder.encode do |json|
      json.instance_eval(jbuilder_template)
      json.target!
    end
  end
  x.report(format("%-36.36s", "Representable #{Gem.loaded_specs["representable"].version}")) do
    UserRepresenter.new(user).to_json
  end
  x.report(format("%-36.36s", "AMS #{ActiveModel::Serializer::VERSION}")) do
    UserActiveSerializer.new(user).to_json
  end
  x.report(format("%-36.36s", "FastJsonapi #{Gem.loaded_specs["fast_jsonapi"].version}")) do
    UserFastSerializer.new(user).serialized_json
  end
  x.report(format("%-36.36s", "Rabl #{Rabl::VERSION}")) { Rabl::Renderer.json(user, rabl_template) }
end

Benchie.end
Benchie.print_suite_summary
