# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.belongs_to' do
  it do
    expect(described_class.belongs_to(belongs_to: 'amount,description,name')).to eq(%w[amount description name])
  end
end
