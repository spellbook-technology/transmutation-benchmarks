# frozen_string_literal: true

require "bundler/setup"

Bundler.require

Oj.mimic_JSON # Use OJ for benchmarks using #to_json
MultiJson.use(:oj) # Use OJ by default from multi_json

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path("lib", __dir__))
loader.collapse(File.expand_path("lib/models", __dir__))
loader.collapse(File.expand_path("lib/serializers", __dir__))
loader.setup

Rabl.configure do |config|
  config.include_json_root = false
end

jbuilder_template = File.read(File.expand_path("lib/views/users/show.json.jbuilder", __dir__))
rabl_template = File.read(File.expand_path("lib/views/users/show.json.rabl", __dir__))

user = User.new(id: 1, first_name: "John", last_name: "Doe", organisation_id: 1)

SerializerBenchmarks.report do
  group("Attributes") do
    example("transmutation")            { Transmutation::UserSerializer.new(user).to_json }
    example("panko_serializer")         { PankoSerializer::UserSerializer.new.serialize_to_json(user) }
    example("jbuilder")                 { Jbuilder.encode { |json| json.instance_eval(jbuilder_template); json.target! } }
    example("representable")            { Representable::UserRepresenter.new(user).to_json }
    example("active_model_serializers") { ActiveModelSerializers::UserSerializer.new(user).to_json }
    example("rabl")                     { Rabl::Renderer.json(user, rabl_template) }
    example("jsonapi-serializer")       { Jsonapi::UserSerializer.new(user).to_json }
  end

  # benchmark.group("Has One / Belongs To") do |group|
  #   group.add(:transmutation)            { Transmutation::UserSerializer.new(user).to_json }
  #   group.add(:panko_serializer)         { PankoSerializer::UserSerializer.new.serialize_to_json(user) }
  #   group.add(:jbuilder)                 { JBuilder.encode { |json| json.instance_eval(jbuilder_template); json.target! } }
  #   group.add(:representable)            { Representable::UserSerializer.new(user).to_json }
  #   group.add(:active_model_serializers) { ActiveModelSerializers::SerializableResource.new(user).as_json }
  #   group.add(:rabl)                     { Rabl::Renderer.json(user, rabl_template) }
  #   group.add(:fast_jsonapi)             { FastJsonapi::UserSerializer.new(user).to_json }
  # end

  # benchmark.group("Has Many") do |group|
  #   group.add(:transmutation)            { Transmutation::UserSerializer.new(user).to_json }
  #   group.add(:panko_serializer)         { PankoSerializer::UserSerializer.new.serialize_to_json(user) }
  #   group.add(:jbuilder)                 { JBuilder.encode { |json| json.instance_eval(jbuilder_template); json.target! } }
  #   group.add(:representable)            { Representable::UserSerializer.new(user).to_json }
  #   group.add(:active_model_serializers) { ActiveModelSerializers::SerializableResource.new(user).as_json }
  #   group.add(:rabl)                     { Rabl::Renderer.json(user, rabl_template) }
  #   group.add(:fast_jsonapi)             { FastJsonapi::UserSerializer.new(user).to_json }
  # end
end
