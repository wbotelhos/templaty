# frozen_string_literal: true

module Templaty
  module Logger
    module_function

    def call(method_name, message)
      puts("[#{method_name}] #{message}")
    end
  end
end
