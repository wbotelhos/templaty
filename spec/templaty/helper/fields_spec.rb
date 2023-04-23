# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.fields' do
  it do
    expect(<%= params.model_class %>.fields(fields: 'amount,description,name')).to eq(%w[amount description name])
  end
end
