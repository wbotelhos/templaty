# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.data_wrap' do
  it 'returns string when value is a string' do
    expect(<%= params.model_class %>.data_wrap('value')).to eq("'value'")
  end

  it 'returns the raw value when value is not a string' do
    expect(<%= params.model_class %>.data_wrap(123)).to eq(123)
  end
end
