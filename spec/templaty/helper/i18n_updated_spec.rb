# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_updated' do
  it do
    expect(described_class.i18n_updated(gender: 'male')).to eq('atualizado')
    expect(described_class.i18n_updated(gender: 'female')).to eq('atualizada')
  end
end
