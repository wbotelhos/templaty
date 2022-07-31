# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.rspec_matcher' do
  it 'returns the right rspec matcher based on the value' do
    expect(described_class.rspec_matcher('')).to eq("eq('')")
    expect(described_class.rspec_matcher('value')).to eq("eq('value')")
    expect(described_class.rspec_matcher(42)).to eq('be(42)')
    expect(described_class.rspec_matcher(nil)).to eq('be(nil)')
  end
end
