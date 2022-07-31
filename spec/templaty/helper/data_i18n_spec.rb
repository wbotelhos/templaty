# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.data_i18n' do
  let!(:options) { { fields: 'amount,description,name', fields_i18n: 'Valor,Descrição,Nome' } }

  it do
    expect(described_class.data_i18n(options)).to eq(
      'amount' => 'Valor',
      'description' => 'Descrição',
      'name' => 'Nome',
    )
  end
end
