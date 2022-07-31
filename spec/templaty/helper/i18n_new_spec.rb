# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_new' do
  it do
    expect(described_class.i18n_new(gender: 'male')).to eq('novo')
    expect(described_class.i18n_new(gender: 'female')).to eq('nova')
  end
end
