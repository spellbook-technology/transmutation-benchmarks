# frozen_string_literal: true

require "bundler/setup"
require "active_support/core_ext/object/deep_dup" # Required for Active Model Serializers

Bundler.require

Oj.optimize_rails # Use OJ for benchmarks using #to_json
MultiJson.use(:oj) # Use OJ by default from multi_json

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path("lib", __dir__))
loader.collapse(File.expand_path("lib/models", __dir__))
loader.collapse(File.expand_path("lib/serializers", __dir__))
loader.setup

Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end

user_jbuilder_template = File.read(File.expand_path("lib/views/users/show.json.jbuilder", __dir__))
post_jbuilder_template = File.read(File.expand_path("lib/views/posts/show.json.jbuilder", __dir__))
organisation_jbuilder_template = File.read(File.expand_path("lib/views/organisations/show.json.jbuilder", __dir__))

user_rabl_template = File.read(File.expand_path("lib/views/users/show.json.rabl", __dir__))
post_rabl_template = File.read(File.expand_path("lib/views/posts/show.json.rabl", __dir__))
organisation_rabl_template = File.read(File.expand_path("lib/views/organisations/show.json.rabl", __dir__))

organisation = Organisation.new(id: 1, name: "Example Inc.")
user = User.new(id: 1, first_name: "John", last_name: "Doe", organisation_id: 1)
post = Post.new(id: 1, title: "Sample Post", body: "Sample Body", user_id: 1)

GemBenchmarks.report output: false do
  group("Attributes") do
    example("transmutation")            { Transmutation::OrganisationSerializer.new(organisation).to_json }
    example("panko_serializer")         { PankoSerializer::OrganisationSerializer.new.serialize_to_json(organisation) }
    example("jbuilder")                 { Jbuilder.encode { |json| json.instance_eval(organisation_jbuilder_template); json.target! } }
    example("representable")            { Representable::OrganisationRepresenter.new(organisation).to_json }
    example("active_model_serializers") { ActiveModelSerializers::OrganisationSerializer.new(organisation, namespace: ActiveModelSerializers).to_json }
    example("rabl")                     { Rabl::Renderer.json(organisation, organisation_rabl_template) }
    example("alba")                     { Alba::OrganisationResource.new(organisation).serialize }
  end

  group("Has One / Belongs To") do
    example("transmutation")            { Transmutation::PostSerializer.new(post).to_json }
    example("panko_serializer")         { PankoSerializer::PostSerializer.new(except: { user: [:posts] }).serialize_to_json(post) }
    example("jbuilder")                 { Jbuilder.encode { |json| json.instance_eval(post_jbuilder_template); json.target! } }
    example("representable")            { Representable::PostRepresenter.new(post).to_json }
    example("active_model_serializers") { ActiveModelSerializers::PostSerializer.new(post, namespace: ActiveModelSerializers).to_json }
    example("rabl")                     { Rabl::Renderer.json(post, post_rabl_template) }
    example("alba")                     { Alba::PostResource.new(post, within: :user).serialize }
  end

  group("Has Many") do
    example("transmutation")            { Transmutation::UserSerializer.new(user).to_json }
    example("panko_serializer")         { PankoSerializer::UserSerializer.new.serialize_to_json(user) }
    example("jbuilder")                 { Jbuilder.encode { |json| json.instance_eval(user_jbuilder_template); json.target! } }
    example("representable")            { Representable::UserRepresenter.new(user).to_json }
    example("active_model_serializers") { ActiveModelSerializers::UserSerializer.new(user, namespace: ActiveModelSerializers).to_json }
    example("rabl")                     { Rabl::Renderer.json(user, user_rabl_template) }
    example("alba")                     { Alba::UserResource.new(user, within: :posts).serialize }
  end
end
