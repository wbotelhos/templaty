# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.data_as_hash_string' do
  let!(:data) do
    {
      'amount_cents' => { raw: 123_45, formatted: 'R$ 123,45' },
      'description' => { raw: 'description', formatted: 'description' },
      'name' => { raw: 'name', formatted: 'name' },
      'percentage_cents' => { raw: 98_34, formatted: '98,34 %' },
    }
  end

  it 'returns key and formatted values' do
    expected = "amount_cents: 'R$ 123,45', description: 'description', name: 'name', percentage_cents: '98,34 %'"

    expect(described_class.data_as_hash_string(data)).to eq(expected)
  end

  context 'when change the value attribute' do
    it 'returns key and value for the given attribute' do
      expected = "amount_cents: 12345, description: 'description', name: 'name', percentage_cents: 9834"

      expect(described_class.data_as_hash_string(data, value_attribute: :raw)).to eq(expected)
    end
  end
end
