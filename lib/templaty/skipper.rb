# frozen_string_literal: true

module Templaty
  module Skipper
    module_function

    def skip?(path)
      return false unless File.file?(path)

      File.read(path).lines.first&.strip&.include?('templaty:skip')
    end
  end
end
