# frozen_string_literal: true

module Templaty
  class Option
    def initialize(options)
      @options = options
    end

    def to_a(option)
      options[option.to_sym]&.split(',') || []
    end

    private

    attr_reader :options
  end
end
