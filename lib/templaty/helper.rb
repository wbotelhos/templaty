# frozen_string_literal: true

require 'faker'

module Templaty
  module Helper
    module_function

    def belongs_to(options)
      return [] if options[:belongs_to].nil?

      options[:belongs_to].split(',')
    end

    def data(field)
      amount = Faker::Number.number(digits: 5)
      description = Faker::Lorem.paragraphs.join("\r\n\n")
      name = Faker::Artist.name
      percentage = Faker::Number.number(digits: 4)

      {
        'amount_cents' => { raw: amount, formatted: ::Helper.money(amount, type: :cents) },
        'description' => { raw: description, formatted: description },
        'name' => { raw: name, formatted: name },
        'percentage_cents' => { raw: percentage, formatted: ::Helper.percentage(percentage, type: :cents) },
      }[field] || { field => { raw: 'any', formatted: 'any' } }
    end

    def data_as_hash_string(data, value_attribute: :formatted)
      data.map { |key, value| "#{key}: #{data_wrap(value[value_attribute])}" }.join(', ')
    end

    def data_for(options)
      fields(options)
        .sort
        .reduce({}) { |acc, field| acc.tap { |data| data[field] = Templaty::Helper.data(field) } }
        .tap do |_field, item|
          if options[:avatar]
            item << { 'avatar' => { raw: "fixture_image('image.jpg')", formatted: "fixture_image('image.jpg')" } }
          end

          if options[:cover]
            item << { 'cover' => { raw: "fixture_image('image.png')", formatted: "fixture_image('image.png')" } }
          end

          if options[:photos]
            item << {
              'photos' => {
                raw: "[fixture_image('image-1.jpg'), fixture_image('image-2.jpg')]",
                formatted: "[fixture_image('image-1.jpg'), fixture_image('image-2.jpg')]",
              },
            }
          end
        end
    end

    def data_i18n(options)
      fields(options).zip(fields_i18n(options)).to_h
    end

    def data_wrap(value)
      value.is_a?(String) ? "'#{value}'" : value
    end

    def fields(options)
      options[:fields].split(',')
    end

    def fields_i18n(options)
      options[:fields_i18n].split(',')
    end

    def fields_presence(options)
      options[:fields_presence].split(',')
    end

    def fields_grid(options)
      options[:fields_grid].split(',').map { |item| [item.split(':')].flatten.map(&:to_i) }
    end

    def fields_grid_style(options)
      fields_grid(options).flatten.map do |number|
        case number.to_i
        when 50
          {
            'margin-left' => '16px',
            'width' => 'calc(50% - 24px)',
          }
        when 100
          {
            'margin-left' => '16px',
            'width' => 'calc(100% - 32px)',
          }
        end
      end
    end

    def i18n_created(options)
      options[:gender] == 'male' ? 'criado' : 'criada'
    end

    def i18n_new(options)
      options[:gender] == 'male' ? 'novo' : 'nova'
    end

    def i18n_removed(options)
      options[:gender] == 'male' ? 'removido' : 'removida'
    end

    def i18n_this(options)
      options[:gender] == 'male' ? 'este' : 'esta'
    end

    def i18n_updated(options)
      options[:gender] == 'male' ? 'atualizado' : 'atualizada'
    end

    def rspec_matcher(value)
      return "be(#{value.inspect})" if value.nil? || value.is_a?(Numeric)
      return "eq('')" if value == ''

      "eq('#{value}')"
    end

    def validates_numericality(options)
      options[:validates_numericality]&.split(',')&.reduce({}) do |acc, item|
        field, min, max = item.split(':')

        acc.tap { |data| data[field] = { min: min, max: max } }
      end
    end
  end
end
