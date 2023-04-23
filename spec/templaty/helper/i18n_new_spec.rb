# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_new' do
  it do
    expect(<%= params.model_class %>.i18n_new(gender: 'male')).to eq('novo')
    expect(<%= params.model_class %>.i18n_new(gender: 'female')).to eq('nova')
  end
end
