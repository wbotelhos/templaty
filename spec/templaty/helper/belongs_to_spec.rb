# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.belongs_to' do
  it 'when value is given' do
    expect(described_class.belongs_to(belongs_to: 'amount,description,name')).to eq(%w[amount description name])
  end

  it 'when value is not given' do
    expect(described_class.belongs_to(other: :attribute)).to eq([])
  end
end
