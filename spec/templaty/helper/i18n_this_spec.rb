# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_this' do
  it do
    expect(described_class.i18n_this(gender: 'male')).to eq('este')
    expect(described_class.i18n_this(gender: 'female')).to eq('esta')
  end
end
