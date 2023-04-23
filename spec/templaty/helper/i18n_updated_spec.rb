# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_updated' do
  it do
    expect(<%= params.model_class %>.i18n_updated(gender: 'male')).to eq('atualizado')
    expect(<%= params.model_class %>.i18n_updated(gender: 'female')).to eq('atualizada')
  end
end
