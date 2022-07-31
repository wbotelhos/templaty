# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.i18n_created' do
  it do
    expect(described_class.i18n_created(gender: 'male')).to eq('criado')
    expect(described_class.i18n_created(gender: 'female')).to eq('criada')
  end
end
