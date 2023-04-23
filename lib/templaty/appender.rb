# frozen_string_literal: true

module Templaty
  class Appender
    def initialize(context, method_name)
      @context = context
      @method_name = method_name
    end

    def self.call(context, method_name, path, content)
      new(context, method_name).call(path, content)
    end

    def call(path, content)
      Templaty::Directory.create(path)

      return log('Skipped') if Templaty::Skipper.skip?(path)

      log("appending into #{path}")

      context.append_to_file(path, "#{content}\n")
    rescue Errno::ENOENT => e
      log("Error: #{e.message}")
    end

    private

    attr_reader :context, :method_name

    def log(message)
      puts("[Appender#call][#{method_name}] #{message}")
    end
  end
end
