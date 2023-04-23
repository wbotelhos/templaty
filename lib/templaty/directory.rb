# frozen_string_literal: true

module Templaty
  module Directory
    module_function

    def create(path)
      FileUtils.mkdir_p(path.split('/').tap(&:pop).join('/'))
    end
  end
end
