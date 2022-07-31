# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_removed' do
  it do
    expect(described_class.i18n_removed(gender: 'male')).to eq('removido')
    expect(described_class.i18n_removed(gender: 'female')).to eq('removida')
  end
end
