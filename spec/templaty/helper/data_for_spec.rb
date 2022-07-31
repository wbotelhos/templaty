# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.data_for' do
  before do
    allow(Faker::Lorem).to receive(:paragraphs).and_return(['description'])
    allow(Faker::Artist).to receive(:name).and_return('name')
  end

  it 'returns raw and formatted data with keys ordered by name' do
    fields = %w[
      name
      amount_cents
      percentage_cents
      description
    ].join(',')

    expected = {
      'amount_cents' => { raw: 123_45, formatted: 'R$ 123,45' },
      'description' => { raw: 'description', formatted: 'description' },
      'name' => { raw: 'name', formatted: 'name' },
      'percentage_cents' => { raw: 98_34, formatted: '98,34 %' },
    }

    expect(described_class.data_for(fields:)).to eq(expected)
  end
end
