# frozen_string_literal: true

module Templaty
  class Params
    def initialize(options)
      @options = options
      @params = JSON.parse(File.read('.templaty.json'), object_class: OpenStruct) # rubocop:disable Style/OpenStructUse
    end

    def action?(action)
      raw.controller.actions.include?(action)
    end

    def actions_spaced
      raw.controller.actions.sort.join(' ')
    end

    def authorization_except
      return if raw.authorization.except.empty?

      ", except: %i[#{raw.authorization.except.join(' ')}]"
    end

    def belongs_to_fields
      raw.model.belongs_to
    end

    def belongs_to_fields_string
      belongs_to_fields.map { |field| "#{field.name}: #{field.name}" }.join(', ')
    end

    def controller_namespaced_class
      "#{model_class.pluralize}Controller"
    end

    def controller_unamespaced_class
      "#{model_unamespaced_class.pluralize}Controller"
    end

    def controller_path
      [raw.namespace, model_plural].compact.join('/')
    end

    def edit_path
      "[:edit, :#{raw.namespace}, #{parent_resources_instance_string}, :#{model_plural}, #{raw.model.name}]"
    end

    def fields_by_grid
      raw.view.grid.map do |grid_item|
        fields = raw.model.fields.select { |field| grid_item.fields.include?(field.name) }

        Struct.new(:clazz, :fields).new(grid_item.class, fields)
      end
    end

    def form_model
      if raw.namespace && raw.model.namespace
        "[:#{raw.namespace}, #{parent_resources_instance_string}, :#{model_plural}, @#{raw.model.name}]"
      elsif raw.namespace
        "[:#{raw.namespace}, @#{raw.model.name}]"
      elsif raw.model.namespace
        "[:#{raw.model.namespace}, #{parent_resources_instance_string}, @#{raw.model.name}]"
      else
        "@#{raw.model.name}"
      end
    end

    def gridy_path
      "[:gridy, :#{raw.namespace}, #{parent_resources_instance_string}, :#{model_plural}, #{raw.model.name}]"
    end

    def gridy_view # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      content = []

      content << "    json.edit_path(#{edit_path})" if action?('edit')

      content << %(    json.more_image(image_path('icons/ellipsis.svg'))) if action?('edit') || action?('show')

      content << "    json.show_path(#{show_path})" if action?('show')

      raw.model.fields.each do |field|
        content << if field.name.end_with?('_percent') || field.name == 'percentage'
                     "    json.#{field.sub('_percent', '')}(Helper.percentage(#{raw.model.name}.#{field.name}))"
                   elsif field.name.end_with?('_cents')
                     "    json.#{field.sub('_cents', '')}(Helper.money(#{raw.model.name}.#{field.name}))"
                   else
                     "    json.#{field.name}(#{raw.model.name}.#{field.name})"
                   end
      end

      content.sort.join("\n")
    end

    def i18n_created
      male? ? 'criado' : 'criada'
    end

    def i18n_destroyed
      male? ? 'apagado' : 'apagada'
    end

    def i18n_new
      male? ? 'novo' : 'nova'
    end

    def i18n_not_found
      'inexistente'
    end

    def i18n_this
      male? ? 'este' : 'esta'
    end

    def i18n_updated
      male? ? 'atualizado' : 'atualizada'
    end

    def index_path(instance: false)
      values = [":#{raw.namespace}", parent_resources(instance: instance), ":#{model_plural}"].flatten

      "[#{values.join(', ')}]"
    end

    def male?
      raw.model.genre == 'male'
    end

    def model_attributes
      hash = {}

      raw.model.belongs_to.each do |field|
        hash[field.name] = if field.name == 'unit'
                             'current_unit'
                           elsif field.name == 'school'
                             'current_school'
                           else
                             field.name
                           end
      end

      raw.model.fields.each_with_object(hash) do |(field, _data), acc|
        acc[field.name] = "'#{field.name}'"
      end

      hash.sort_by { |key, _value| key }
    end

    def model_attributes_string
      hash_to_string(model_attributes)
    end

    def model_class
      [model_namespace_class, model_unamespaced_class].compact.join('::')
    end

    def model_unamespaced_class
      raw.model.name.classify
    end

    def model_class_plural
      model_class.pluralize
    end

    def model_class_spaces
      raw.model.namespace ? '  ' : ''
    end

    def model_fields
      raw.model.fields.map(&:name).sort
    end

    def model_fields_symbolized
      raw.model.fields.map { |field| ":#{field.name}" }.sort.join(', ')
    end

    def model_fields_spaced
      model_fields.join(' ')
    end

    def model_plural
      raw.model.name.pluralize
    end

    def model_namespace_class
      return if raw.model.namespace.empty?

      value = raw.model.namespace.classify

      # After pluralize it keeps equal, the previous value was already in plural
      raw.model.namespace.pluralize == raw.model.namespace ? value.pluralize : value
    end

    def namespace_class
      return if raw.namespace.empty?

      value = raw.namespace.classify

      # After pluralize it keeps equal, the previous value was already in plural
      raw.namespace.pluralize == raw.namespace ? value.pluralize : value
    end

    def namespace_singular
      raw.namespace.singularize
    end

    def new_path
      "[:new, :#{raw.namespace}, #{parent_resources_instance_string}, :#{model_plural}]"
    end

    def numeric_fields
      raw.model.fields.select(&:numeric)
    end

    def parent_resources(instance: false)
      raw.model.parent_resources.map { |item| [instance ? "@#{item}" : item, ":#{item}"] }.flatten.reverse
    end

    def presence_fields
      raw.model.fields.select(&:presence)
    end

    def raw
      params
    end

    def searchable?
      raw.model.searchable.fields.any?
    end

    def searchable_fields_spaced
      raw.model.searchable.fields.sort.join(' ')
    end

    def show_path
      "[:#{raw.namespace}, #{parent_resources_instance_string}, :#{model_plural}, #{raw.model.name}]"
    end

    def site?
      raw.namespace == 'site'
    end

    def system?
      raw.namespace == 'system'
    end

    def unique_fields
      raw.model.fields.select(&:unique)
    end

    private

    attr_reader :options, :params

    def hash_to_string(hash)
      hash.map { |key, value| "#{key}: #{value}" }.join(', ')
    end

    def parent_resources_instance
      parent_resources.map { |item| "@#{item}" }
    end

    def parent_resources_instance_string
      parent_resources_instance.join(', ')
    end
  end
end
