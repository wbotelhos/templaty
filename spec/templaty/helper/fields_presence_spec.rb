# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.fields_presence' do
  it 'returns a sorted items' do
    result = described_class.fields_presence(fields_presence: 'amount,description,name')

    expect(result).to eq(%w[amount description name])
  end
end
