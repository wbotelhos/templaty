# frozen_string_literal: true

module Templaty
  module Migrations
    class AddColumnGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      class_option :table,  required: true, type: :string, desc: 'Table name'
      class_option :column, required: true, type: :string, desc: 'Column name'
      class_option :type,   required: true, type: :string, desc: 'Column type'

      class_option :default,       required: false, type: :string,  default: nil,   desc: 'Column default value'
      class_option :null,          required: false, type: :boolean, default: nil,   desc: 'Column accept null values?'
      class_option :rails_version, required: false, type: :string,  default: '6.1', desc: 'Rails version'

      # Add the column without a default value.
      #
      # https://github.com/ankane/strong_migrations#good-1
      #
      def add_column
        if options[:null] == false && options[:default].blank?
          raise('[Templaty] Options "default" cannot be blank when option "null" is false.')
        end

        target = "db/migrate/#{timestamp(0)}_add_column_#{options[:column]}_to_#{params.raw.model.name}.rb"

        template('db/migrate/add_column.rb.erb', target)

        `open #{target}`
      end

      # There are three keys to backfilling safely: batching, throttling, and running it outside a transaction.
      # Use the Rails console or a separate migration with disable_ddl_transaction!.
      #
      # https://github.com/ankane/strong_migrations#good-2
      #
      def backfill
        return unless options.key?(:default) || options[:null] != true # non declared null is `null: true`

        target = "db/migrate/#{timestamp(1)}_backfill_#{options[:column]}_to_#{params.model_plural}.rb"

        template('db/migrate/backfill.rb.erb', target)

        `open #{target}`
      end

      # Change the default.
      # https://github.com/ankane/strong_migrations#good-1
      #
      def set_default
        return unless options.key?(:default)

        target = "db/migrate/#{timestamp(2)}_set_column_#{options[:column]}_default_to_#{params.model_plural}.rb"

        template('db/migrate/set_default.rb.erb', target)

        `open #{target}`
      end

      # Add a check constraint.
      #
      # https://github.com/ankane/strong_migrations#good-11
      #
      def not_null
        return unless options[:null] == false

        target = "db/migrate/#{timestamp(3)}_not_null_#{options[:column]}_to_#{params.model_plural}.rb"

        template('db/migrate/not_null.rb.erb', target)

        `open #{target}`
      end

      # Then validate it in a separate migration. A NOT NULL check constraint is functionally equivalent to
      # setting NOT NULL on the column.
      # In Postgres 12+, once the check constraint is validated, you can safely set NOT NULL on the column and drop
      # the check constraint.
      #
      # https://github.com/ankane/strong_migrations#good-11
      #
      def validate_not_null
        return unless options[:null] == false

        target = "db/migrate/#{timestamp(4)}_validate_not_null_#{options[:column]}_to_#{params.model_plural}.rb"

        template('db/migrate/validate_not_null.rb.erb', target)

        `open #{target}`
      end

      private

      def time
        @time ||= Time.current
      end

      def timestamp(seconds)
        (time + seconds.seconds).strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
