# frozen_string_literal: true

module Templaty
  class Creator
    def initialize(context, method_name)
      @context = context
      @method_name = method_name
    end

    def self.call(context, method_name, from, to)
      new(context, method_name).call(from, to)
    end

    def call(from, to)
      Templaty::Directory.create(to)

      return log('Skipped') if Templaty::Skipper.skip?(to)

      log("#{from} -> #{to}")

      context.template(from, to)
    rescue Errno::ENOENT => e
      log("Error: #{e.message}")
    end

    private

    attr_reader :context, :method_name

    def log(message)
      puts("[#{method_name}] #{message}")
    end
  end
end
