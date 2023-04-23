# frozen_string_literal: true

module Templaty
  class CrudGenerator < Rails::Generators::Base
    source_root File.expand_path('./templates', __dir__)

    def controller
      params = Templaty::Params.new(options)

      return if params.raw.controller.ignore?

      from = 'crud/app/controllers/namespace/controller.rb.erb'
      to   = "app/controllers/#{params.raw.namespace}/#{params.model_plural}_controller.rb"

      Templaty::Creator.call(self, __method__, from, to)
    end

    def hbs
      params = Templaty::Params.new(options)

      return if params.raw.hbs.ignore?

      params.raw.hbs.actions.each do |action|
        from = 'crud/app/javascript/templates/namespace/model_plural.action.hbs.erb'
        to = "app/javascript/templates/#{params.raw.namespace}/#{params.model_plural}.#{action}.hbs"

        Templaty::Logger.call(__method__, "#{from} -> #{to}")

        Templaty::Creator.call(self, __method__, from, to)
      end
    end

    def i18n
      params = Templaty::Params.new(options)

      return if params.raw.i18n.ignore?

      params.raw.i18n.locales.each do |locale|
        # Controller

        params.raw.controller.i18n.actions.each do |name|
          from = "crud/config/locales/#{locale}/namespace/model_plural/#{name}.yml.erb"
          to   = "config/locales/#{locale}/#{params.raw.namespace}/#{params.model_plural}/#{name}.yml"

          Templaty::Logger.call(__method__, "#{from} -> #{to}")

          Templaty::Creator.call(self, __method__, from, to)
        end

        # Model

        from = "crud/config/locales/#{locale}/model.yml.erb"
        to = "config/locales/#{locale}/#{params.raw.model.name}.yml"

        Templaty::Logger.call(__method__, "#{from} -> #{to}")

        Templaty::Creator.call(self, __method__, from, to)
      end
    end

    def js
      params = Templaty::Params.new(options)

      return if params.raw.js.ignore?

      params.raw.js.actions.each do |action|
        # JS
        from = "crud/app/javascript/pages/namespace/views/model_plural/#{action}.js.erb"
        to = "app/javascript/pages/#{params.raw.namespace}/views/#{params.model_plural}/#{action}.js"

        Templaty::Logger.call(__method__, "#{from} -> #{to}")

        Templaty::Creator.call(self, __method__, from, to)

        # Manifest

        content = "import '@/pages/#{params.raw.namespace}/views/#{params.model_plural}/#{action}';"
        path = "app/javascript/#{params.namespace_singular}.js"

        Templaty::Appender.call(self, __method__, path, content)
      end
    end

    def model
      params = Templaty::Params.new(options)

      return if params.raw.model.ignore?

      from = 'crud/app/models/model.rb.erb'
      to = "app/models/#{[params.raw.model.namespace, params.raw.model.name].compact.join('/')}.rb"

      Templaty::Logger.call(__method__, "#{from} -> #{to}")

      Templaty::Creator.call(self, __method__, from, to)
    end

    def route_resource
      params = Templaty::Params.new(options)

      return if params.raw.route.ignore?
      return if Templaty::Skipper.skip?('config/routes.rb')

      # route %(
      #   concern :gridyable do
      #     get :gridy, defaults: { format: :json }, on: :collection
      #   end
      # )

      properties = [
        ":#{params.model_plural}",
        params.raw.controller.actions.include?('gridy') ? 'concerns: :gridyable' : nil,
        "only: %i[#{params.raw.controller.actions.excluding('gridy').sort.join(' ')}]",
        "path: :#{params.raw.route.path}",
        %(path_names: { new: #{params.male? ? "'novo'" : 'nova'}, edit: 'editar' }),
      ].compact

      route(%(resources #{properties.join(",\n ")}), namespace: params.raw.namespace)
    end

    def seed
      params = Templaty::Params.new(options)

      return if params.raw.seed.ignore?

      from = 'crud/db/seeds/pd/model_plural.rb.erb'
      to   = "db/seeds/pd/#{params.model_plural}.rb"

      Templaty::Logger.call(__method__, "#{from} -> #{to}")

      Templaty::Creator.call(self, __method__, from, to)
    end

    def shared
      params = Templaty::Params.new(options)

      return if params.raw.shared.ignore?
      return if params.raw.namespace != 'system'

      to = "app/views/shared/icons/_#{params.raw.model.name}.html.erb"

      return if Templaty::Skipper.skip?(to)

      from = 'crud/app/views/shared/_icon.html.erb.erb'

      Templaty::Logger.call(__method__, "#{from} -> #{to}")

      Templaty::Creator.call(self, __method__, from, to)
    end

    def spec
      params = Templaty::Params.new(options)

      return if params.raw.spec.ignore?

      specs = []

      specs << 'spec/controllers/namespace/model_plural/new_spec.rb' if params.action?('new')
      specs << 'spec/controllers/namespace/model_plural/edit_spec.rb' if params.action?('edit')

      if params.action?('create')
        specs += %w[
          spec/controllers/namespace/model_plural/create_spec.rb
          spec/features/namespace/model_plural/create_spec.rb
        ]
      end

      if params.action?('destroy')
        specs += %w[
          spec/controllers/namespace/model_plural/destroy_spec.rb
          spec/features/namespace/model_plural/destroy_spec.rb
        ]
      end

      if params.action?('index')
        specs += %w[
          spec/controllers/namespace/model_plural/gridy/json_spec.rb
          spec/controllers/namespace/model_plural/gridy/unlogged_spec.rb
          spec/controllers/namespace/model_plural/index_spec.rb
          spec/features/namespace/model_plural/gridy/initial_spec.rb
          spec/features/namespace/model_plural/gridy/search_spec.rb
          spec/features/namespace/model_plural/gridy/sort_spec.rb
        ]

        specs << 'spec/models/model/list_spec.rb' if params.searchable?
      end

      if params.action?('update')
        specs += %w[
          spec/controllers/namespace/model_plural/update_spec.rb
        ]
      end

      specs.sort.each do |path|
        from = "crud/#{path}.erb"

        to = path
             .sub('namespace', params.raw.namespace)
             .sub('model_plural', params.model_plural)

        Templaty::Logger.call(__method__, "#{from} -> #{to}")

        Templaty::Creator.call(self, __method__, from, to)
      end
    end

    def views
      params = Templaty::Params.new(options)

      return if params.raw.view.ignore?

      pages = []

      pages << '_form.html.erb' if params.action?('new') || params.action?('edit')
      pages << 'edit.html.erb' if params.action?('edit')
      pages << 'gridy.json.jbuilder' if params.action?('gridy')
      pages << 'index.html.erb' if params.action?('index')
      pages << 'new.html.erb' if params.action?('new')

      pages += %w[_submenu.html.erb _title.html.erb] if params.system?

      pages.each do |name|
        from = "crud/app/views/namespace/model_plural/#{name}.erb"
        to = "app/views/#{params.raw.namespace}/#{params.model_plural}/#{name}"

        Templaty::Logger.call(__method__, "#{from} -> #{to}")

        Templaty::Creator.call(self, __method__, from, to)
      end
    end
  end
end
