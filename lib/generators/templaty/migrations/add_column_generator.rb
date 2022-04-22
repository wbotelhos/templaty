# frozen_string_literal: true

module Templaty
  module Migrations
    class AddColumnGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      TEMPLATE = 'db/migrate/add_column.rb.erb'

      class_option :table,  required: true, type: :string, desc: 'Table name'
      class_option :column, required: true, type: :string, desc: 'Column name'
      class_option :type,   required: true, type: :string, desc: 'Column type'

      class_option :default,       required: false, type: :string,  default: nil,   desc: 'Column default value'
      class_option :null,          required: false, type: :boolean, default: true,  desc: 'Column accept null values?'
      class_option :rails_version, required: false, type: :string,  default: '6.1', desc: 'Rails version'

      def add_column
        method_name = self.class.name.underscore.split('/').last.split('_')[0..-2].join('_')
        target      = "db/migrate/#{timestamp(0)}_#{method_name}_#{options[:column]}_to_#{options[:table].pluralize}.rb"

        template(TEMPLATE, target, pinto: 2)

        `open #{target}`
      end

      private

      def time
        @time ||= Time.current
      end

      def timestamp(seconds)
        (time + seconds.seconds).strftime '%Y%m%d%H%M%S'
      end
    end
  end
end
