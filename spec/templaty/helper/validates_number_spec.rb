# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.validates_numericality' do
  let!(:options) { { validates_numericality: 'percentage_cents:0:100_00,amount_cents:0:999_99' } }

  it do
    expect(described_class.validates_numericality(options)).to eq(
      'amount_cents' => { max: '999_99', min: '0' },
      'percentage_cents' => { max: '100_00', min: '0' }
    )
  end
end
