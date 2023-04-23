# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.fields_i18n' do
  it do
    expect(<%= params.model_class %>.fields_i18n(fields_i18n: 'amount,description,name')).to eq(%w[amount description name])
  end
end
