# frozen_string_literal: true

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
