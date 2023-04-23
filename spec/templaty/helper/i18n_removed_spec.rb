# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_destroyed' do
  it do
    expect(<%= params.model_class %>.i18n_destroyed(gender: 'male')).to eq('removido')
    expect(<%= params.model_class %>.i18n_destroyed(gender: 'female')).to eq('removida')
  end
end
