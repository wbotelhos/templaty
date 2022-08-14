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
    class_option :show_route, required: false, type: :boolean, default: false, desc: 'Add show route? (true|false)'

    class_option :validates_numericality,
      required: false,
      type: :string,
      default: nil,
      desc: 'numericality validation (amount_cents:0:100_00)'

    def controller
      from = 'crud/app/controllers/system/table_controller.rb.erb'
      to   = "app/controllers/system/#{options[:table]}_controller.rb"

      template(from, to)
    end

    def css
      %w[form index].each do |name|
        from = "crud/app/assets/stylesheets/namespace/views/table/#{name}.scss.erb"
        to   = "app/assets/stylesheets/#{options[:namespace]}/views/#{options[:table]}/#{name}.scss"

        template(from, to)
      end
    end

    def hbs
      %w[table.gridy.hbs.erb].each do |name|
        from = "crud/app/assets/templates/namespace/#{name}"
        to   = "app/javascript/templates/#{options[:namespace]}/#{options[:table]}.gridy.hbs"

        template(from, to)
      end

      `gulp hbs`
    end

    def i18n
      actions = %w[create destroy edit index show update]

      %w[en pt-BR ru].each do |locale|
        actions.each do |name|
          next if name == 'show' && options[:show_route] != true

          from = "crud/config/locales/#{locale}/namespace/table/#{name}.yml.erb"
          to   = "config/locales/#{locale}/#{options[:namespace]}/#{options[:table]}/#{name}.yml"

          template(from, to)
        end

        from = "crud/config/locales/#{locale}/model.yml.erb"
        to   = "config/locales/#{locale}/#{options[:table].singularize}.yml"

        template(from, to)
      end
    end

    def js
      %w[form index].each do |name|
        from = "crud/app/javascripts/#{name}.js.erb"
        to   = "app/javascript/pages/#{options[:namespace]}/views/#{options[:table]}/#{name}.js"

        template(from, to)
      end
    end

    def model
      from = 'crud/app/models/model.rb.erb'
      to   = "app/models/#{options[:table].singularize}.rb"

      template(from, to)
    end

    def pages
      %w[
        _form.html.erb
        _submenu.html.erb
        _title.html.erb
        edit.html.erb
        gridy.json.jbuilder
        index.html.erb
        new.html.erb
      ].each do |name|
        from = "crud/app/views/namespace/table/#{name}.erb"
        to = "app/views/#{options[:namespace]}/#{options[:table]}/#{name}"

        template(from, to)
      end
    end

    def route_resource
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
      route %(
        concern :gridyable do
          get :gridy, defaults: { format: :json }, on: :collection
        end
      )
    end

    def seed
      from = 'crud/db/seeds/pd/table.rb.erb'
      to   = "db/seeds/pd/#{options[:table]}.rb"

      template(from, to)
    end

    def shared
      %w[_model.html.erb].each do |name|
        from = "crud/app/views/shared/icons/#{name}.erb"
        to   = "app/views/shared/guide/_#{options[:table].singularize}.html.erb"

        template(from, to)
      end
    end

    def spec
      %w[
        spec/controllers/namespace/table/create_spec.rb
        spec/controllers/namespace/table/destroy_spec.rb
        spec/controllers/namespace/table/edit_spec.rb
        spec/controllers/namespace/table/gridy/json_spec.rb
        spec/controllers/namespace/table/gridy/unlogged_spec.rb
        spec/controllers/namespace/table/index_spec.rb
        spec/controllers/namespace/table/new_spec.rb
        spec/controllers/namespace/table/update_spec.rb
        spec/features/namespace/table/create_spec.rb
        spec/features/namespace/table/destroy_spec.rb
        spec/features/namespace/table/gridy/initial_spec.rb
        spec/features/namespace/table/gridy/search_spec.rb
        spec/features/namespace/table/gridy/sort_spec.rb
        spec/features/namespace/table/update_spec.rb
        spec/models/model/list_spec.rb
      ].each do |path|
        from = "crud/#{path}.erb"

        to = path
             .sub('model', options[:table].singularize)
             .sub('namespace', options[:namespace])
             .sub('table', options[:table])

        template(from, to)
      end
    end

    def warning
      puts("\n=== Plese edit the following files: ===\n\n") # rubocop:disable Rails/Output

      %w[en pt-BR ru].each do |locale|
        puts("code config/locales/#{locale}/#{options[:table].singularize}.yml:5") # rubocop:disable Rails/Output
      end

      puts("code db/seeds/pd/#{options[:table].singularize}.rb") # rubocop:disable Rails/Output
    end
  end
end
