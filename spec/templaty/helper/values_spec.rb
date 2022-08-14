# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.values' do
  it 'when option is given' do
    expect(described_class.values({ belongs_to: 'amount,description' }, :belongs_to)).to eq(%w[amount description])
  end

  it 'when option is not given' do
    expect(described_class.values({ other: :attribute }, :belongs_to)).to eq([])
  end
end
