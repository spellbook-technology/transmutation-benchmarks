# frozen_string_literal: true

class SerializerBenchmarks
  def self.report(&block)
    new(&block).groups.values.each(&:report)
  end

  def initialize(&block)
    instance_eval(&block)
  end

  def groups
    @groups ||= {}
  end

  private

  def group(name, &block)
    groups[name] = Group.new(name, &block)
  end

  class Group
    attr_accessor :name

    def initialize(name, &block)
      @name = name

      instance_eval(&block)
    end

    def calculate_outputs
      examples.each do |name, example|
        example.output = example.run
      end
    end

    def calculate_time
      time_report = Benchmark.ips quiet: true do |x|
        examples.each do |name, example|
          x.report(name) { example.run }
        end
      end

      fastest_entry = time_report.entries.max_by(&:ips)

      time_report.entries.each do |entry|
        examples[entry.label].ips = "#{Benchmark::IPS::Helpers.scale(entry.ips)} #{format("±%4.1f%%", (100.0 * entry.ips_sd.to_f / entry.ips))}"
        examples[entry.label].ips_comparison = fastest_entry.ips != entry.ips ? "#{format("%.2fx slower", fastest_entry.ips.to_f / entry.ips)}" : "baseline"
      end

      time_report
    end

    def calculate_memory
      memory_report = Benchmark.memory quiet: true do |x|
        examples.each do |name, example|
          x.report(name) { example.run }
        end
      end

      smallest_entry = memory_report.entries.min_by { |entry| entry.measurement.memory.allocated }

      memory_report.entries.each do |entry|
        examples[entry.label].allocations = Benchmark::Memory::Helpers.scale(entry.measurement.memory.allocated)
        examples[entry.label].allocations_comparison = smallest_entry.measurement.memory.allocated != entry.measurement.memory.allocated ? "#{format("%.2fx more", entry.measurement.memory.allocated.to_f / smallest_entry.measurement.memory.allocated)}" : "baseline"
      end

      memory_report
    end

    def calculate
      calculate_outputs
      calculate_time
      calculate_memory

      nil
    end

    def report
      calculate

      table = Terminal::Table.new(title: name, headings:, rows:)

      table.align_column 1, :right
      table.align_column 2, :right
      table.align_column 3, :right
      table.align_column 4, :right
      table.style = { border: :markdown }

      puts table
    end

    def examples
      @examples ||= {}
    end

    def headings
      ["Gem", "IPS", "Comparison", "Allocations", "Comparison", "Output"]
    end

    def rows
      examples.values.lazy.sort_by(&:ips).reverse.map do |example|
        [example.label, example.ips, example.ips_comparison, example.allocations, example.allocations_comparison, example.output]
      end
    end

    private

    def example(name, &block)
      examples[name] = Example.new(name, &block)
    end

    class Example
      attr_accessor :label, :block, :ips, :ips_comparison, :allocations, :allocations_comparison, :output

      def initialize(name, &block)
        @label = "#{name} #{Gem.loaded_specs[name].version}"
        @block = block
      end

      def run
        block.call
      end
    end
  end
end
