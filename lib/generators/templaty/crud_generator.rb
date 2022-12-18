# frozen_string_literal: true

module Templaty
  class CrudGenerator < Rails::Generators::Base
    source_root File.expand_path('./templates', __dir__)

    class_option :fields_grid, required: true, type: :string, desc: 'The grid style for each field'
    class_option :fields_i18n, required: true, type: :string, desc: 'Fields I18n (Nome,Descrição)'
    class_option :fields_presence, required: true, type: :string, desc: 'Mandatory fields (name,total_cents)'
    class_option :fields, required: true, type: :string, desc: 'Resource fields (description,name)'
    class_option :gender, required: true, type: :string, desc: 'Resource gender (criada|criado com sucesso)'
    class_option :name_one, required: true, type: :string, desc: 'Resource name on singular (discount)'
    class_option :name_other, required: true, type: :string, desc: 'Resource name on plural (discounts)'
    class_option :namespace_i18n, required: true, type: :string, desc: 'Template name translation (Sistema)'
    class_option :namespace, required: true, type: :string, desc: 'Template name (admin, system...)'
    class_option :path, required: true, type: :string, desc: 'Route path name (desconto)'
    class_option :table, required: true, type: :string, desc: 'Table name (discounts)'

    class_option :avatar, required: false, type: :boolean, default: false, desc: 'Has avatar? (true|false)'
    class_option :belongs_to, required: false, type: :string, desc: 'the belongs_to relation (user)'
    class_option :cover, required: false, type: :boolean, default: false, desc: 'Has cover? (true|false)'
    class_option :multipart, required: false, type: :boolean, default: false, desc: 'Multipart form? (true|false)'
    class_option :photos, required: false, type: :boolean, default: false, desc: 'Has photos? (true|false)'
    class_option :rails_version, required: false, type: :string, default: '6.1', desc: 'Rails version'
    class_option :ignore_routes, required: false, type: :boolean, default: false, desc: 'Ignores the routes (true|false)'

    class_option :show_route, required: false, type: :boolean, default: false, desc: 'Add show route? (true|false)'

    class_option :ignore_actions,
      required: false,
      type: :string,
      default: '',
      desc: "Ignores the controller's actions. (create,destroy)"

    class_option :ignore_controller,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the controller. (true|false)'

    class_option :ignore_css,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores CSS files. (form,index)'

    class_option :ignore_hbs,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the HBS templates. (gridy,search)'

    class_option :ignore_i18n_actions,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the I18n of the given actions. (create,update)'

    class_option :ignore_i18n_locales,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the I18n of the entire given locale. (en,pt-BR)'

    class_option :ignore_js,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the given JS files. (form,index)'

    class_option :ignore_model,
      required: false,
      type: :boolean,
      default: false,
      desc: 'Ignores the model. (true|false)'

    class_option :ignore_seeds,
      required: false,
      type: :boolean,
      default: false,
      desc: 'Ignores the seeds. (true|false)'

    class_option :ignore_shared_icon,
      required: false,
      type: :boolean,
      default: false,
      desc: 'Ignores the shared icon. (true|false)'

    class_option :ignore_specs,
      required: false,
      type: :boolean,
      default: false,
      desc: 'Ignores the given specs. (create,index)'

    class_option :ignore_views,
      required: false,
      type: :string,
      default: '',
      desc: 'Ignores the given views. (_form,index)'

    class_option :validates_numericality,
      required: false,
      type: :string,
      default: nil,
      desc: 'numericality validation (amount_cents:0:100_00)'

    def controller
      return if options[:ignore_model]

      from = 'crud/app/controllers/namespace/table_controller.rb.erb'
      to   = "app/controllers/#{options[:namespace]}/#{options[:table]}_controller.rb"

      template(from, to)
    end

    def css
      ignore_css = Templaty::Helper.values(options, :ignore_css)

      %w[form index].each do |name|
        next if ignore_css.include?(name)

        from = "crud/app/assets/stylesheets/namespace/views/table/#{name}.scss.erb"
        to   = "app/assets/stylesheets/#{options[:namespace]}/views/#{options[:table]}/#{name}.scss"

        template(from, to)
      end
    end

    def hbs
      ignore_hbs = Templaty::Helper.values(options, :ignore_hbs).map { |name| "table.#{name}.hbs.erb" }

      %w[table.gridy.hbs].each do |name|
        next if ignore_hbs.include?(name)

        path = "app/javascript/templates/namespace/#{name}"
        from = "crud/#{path}.erb"

        to = path
             .sub('model', options[:table].singularize)
             .sub('namespace', options[:namespace])
             .sub('table', options[:table])

        template(from, to)
      end

      `gulp hbs`
    end

    def i18n
      ignore_i18n_actions = Templaty::Helper.values(options, :ignore_i18n_actions)
      ignore_i18n_locales = Templaty::Helper.values(options, :ignore_i18n_locales)

      actions = %w[create destroy edit index new show update]

      %w[en pt-BR ru].each do |locale|
        next if ignore_i18n_locales.include?(locale)

        actions.each do |name|
          next if ignore_i18n_actions.include?(name) || (name == 'show' && options[:show_route] != true)

          from = "crud/config/locales/#{locale}/namespace/table/#{name}.yml.erb"
          to   = "config/locales/#{locale}/#{options[:namespace]}/#{options[:table]}/#{name}.yml"

          template(from, to)
        end
      end

      name = options[:table].singularize

      from = "crud/config/locales/#{locale}/#{name}.yml.erb"
      to   = "config/locales/#{locale}/#{name}.yml"

      template(from, to)
    end

    def js
      ignore_js = Templaty::Helper.values(options, :ignore_js)

      %w[form index].each do |name|
        next if ignore_js.include?(name)

        path = "app/javascript/pages/namespace/views/table/#{name}.js"
        from = "crud/#{path}.erb"

        to = path
             .sub('model', options[:table].singularize)
             .sub('namespace', options[:namespace])
             .sub('table', options[:table])

        template(from, to)
      end
    end

    def model
      return if options[:ignore_model]

      from = 'crud/app/models/model.rb.erb'
      to   = "app/models/#{options[:table].singularize}.rb"

      template(from, to)
    end

    def route_resource
      return if options[:ignore_routes]

      content = <<~HEREDOC
        resources :#{options[:table]},
          concerns:   :gridyable,
          #{options[:show_route] ? nil : 'except:     :show,'}
          path:       :#{options[:path]},
          path_names: { new: :novo, edit: :editar }
      HEREDOC

      route content, namespace: options[:namespace]
    end

    def route_gridyable
      return if options[:ignore_routes]

      route %(
        concern :gridyable do
          get :gridy, defaults: { format: :json }, on: :collection
        end
      )
    end

    def seed
      return if options[:ignore_seeds]

      from = 'crud/db/seeds/pd/table.rb.erb'
      to   = "db/seeds/pd/#{options[:table]}.rb"

      template(from, to)
    end

    def shared
      return if options[:ignore_shared_icon]

      from = 'crud/app/views/shared/_icon.html.erb.erb'
      to   = "app/views/shared/icons/_#{options[:table].singularize}.html.erb"

      template(from, to)
    end

    def spec
      ignore_actions = Templaty::Helper.values(options, :ignore_actions)

      specs = []

      unless ignore_actions.include?('create')
        specs += %w[spec/controllers/namespace/table/create_spec.rb spec/features/namespace/table/create_spec.rb]
      end

      unless ignore_actions.include?('destroy')
        specs += %w[spec/controllers/namespace/table/destroy_spec.rb spec/features/namespace/table/destroy_spec.rb]
      end

      specs << 'spec/controllers/namespace/table/edit_spec.rb' unless ignore_actions.include?('edit')

      unless ignore_actions.include?('index')
        specs += %w[
          spec/controllers/namespace/table/gridy/json_spec.rb
          spec/controllers/namespace/table/gridy/unlogged_spec.rb
          spec/controllers/namespace/table/index_spec.rb
          spec/features/namespace/table/gridy/initial_spec.rb
          spec/features/namespace/table/gridy/search_spec.rb
          spec/features/namespace/table/gridy/sort_spec.rb
          spec/models/model/list_spec.rb
        ]
      end

      specs << 'spec/controllers/namespace/table/new_spec.rb' unless ignore_actions.include?('new')

      unless ignore_actions.include?('update')
        specs += %w[spec/controllers/namespace/table/update_spec.rb spec/features/namespace/table/update_spec.rb]
      end

      specs.sort.each do |path|
        from = "crud/#{path}.erb"

        to = path
             .sub('model', options[:table].singularize)
             .sub('namespace', options[:namespace])
             .sub('table', options[:table])

        template(from, to)
      end
    end

    def views
      ignore_views = Templaty::Helper.values(options, :ignore_views)

      %w[
        _form.html.erb
        _submenu.html.erb
        _title.html.erb
        edit.html.erb
        gridy.json.jbuilder
        index.html.erb
        new.html.erb
      ].each do |name|
        next if ignore_views.include?(name.split('.').first)

        from = "crud/app/views/namespace/table/#{name}.erb"
        to = "app/views/#{options[:namespace]}/#{options[:table]}/#{name}"

        template(from, to)
      end
    end
  end
end
