# frozen_string_literal: true

require "benchmark/ips"
require "benchmark-memory"
require "terminal-table"
require "active_support/core_ext/object/deep_dup"

require "transmutation"
require "jbuilder"
require "representable"
require "active_model_serializers"
require "fast_jsonapi"
require "rabl"
require_relative "lib/user"
require_relative "lib/transmutation/user_serializer"
require_relative "lib/representable/user_representer"
require_relative "lib/active_model_serializers/user_serializer"
require_relative "lib/fast_jsonapi/user_serializer"

require "multi_json"
require "oj"
Oj.mimic_JSON # Use OJ for benchmarks using #to_json
MultiJson.use(:oj) # Use OJ by default from multi_json

module SerializationBenchmark # rubocop:disable Style/Documentation
  user = User.new(id: 1, first_name: "John", last_name: "Doe")
  jbuilder_template = File.read(File.expand_path("lib/jbuilder/user.json.jbuilder", __dir__))
  rabl_template = File.read(File.expand_path("lib/rabl/user.json.rabl", __dir__))

  module Benchie # rubocop:disable Style/Documentation
    def self.start
      @start ||= Time.now
    end

    def self.end
      # Don't memoize, use the last call to this method
      @end_time = Time.now
    end

    def self.print_suite_banner
      puts "\n\nUsing Ruby version: #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    end

    def self.print_section_separator(section_title)
      puts "\n\n#{section_title}:\n\n"
    end

    # Basically our own version of calling this process with a `time`
    def self.print_suite_summary
      total_seconds = @end_time - @start
      display_seconds = total_seconds % 60
      display_minutes = total_seconds / 60 % 60
      puts format("\n\nTotal wall clock time: %dm%2.3fs", display_minutes, display_seconds) # rubocop:disable Style/FormatStringToken
    end

    def self.measure(benchmark_name) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      job = nil
      report = Benchmark.ips do |benchmark|
        yield(benchmark)
        job = benchmark
      end

      warmups = job.timing.each_with_object({}) { |kv, h| h[kv.first.label] = kv.last }
      entries = report.entries.sort_by(&:ips)
      rows = entries.map do |e|
        [
          e.label,
          Benchmark::IPS::Helpers.scale(warmups[e.label]),
          Benchmark::IPS::Helpers.scale(e.ips),
          format("±%4.1f%%", (100.0 * e.ips_sd.to_f / e.ips)),
          Benchmark::IPS::Helpers.scale(e.iterations),
          e != entries.last ? format("%.2fx slower", (entries.last.ips.to_f / e.ips)) : ""
        ]
      end

      headings = [benchmark_name, "Warmups\n(i/100ms)", "Iterations\n(i/s)", "Iterations\n(std dev %)",
                  "Total Iterations", "Comparison"]
      puts Terminal::Table.new(headings: headings, rows: rows, style: { border_y: " ", border_i: " ", border_x: "" })
    end

    def self.measure_memory(benchmark_name, &block) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      memory_report = Benchmark.memory(&block)

      memory_entries = memory_report.entries.sort_by { |entry| entry.measurement.memory.allocated }
      rows = memory_entries.map do |e|
        [
          e.label,
          Benchmark::Memory::Helpers.scale(e.measurement.memory.allocated),
          if e != memory_entries.first
            format("%.2fx more",
                   (e.measurement.memory.allocated / memory_entries.first.measurement.memory.allocated.to_f))
          else
            ""
          end
        ]
      end

      headings = [benchmark_name, "Memory Usage", "Comparison"]
      puts Terminal::Table.new(headings: headings, rows: rows, style: { border_y: " ", border_i: " ", border_x: "" })
    end
  end

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
end
