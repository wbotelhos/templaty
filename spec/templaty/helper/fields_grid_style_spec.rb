# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.fields_grid_style' do
  it do
    expect(<%= params.model_class %>.fields_grid_style(fields_grid: '100,50:50')).to eq(
      [
        { 'margin-left' => '16px', 'width' => 'calc(100% - 32px)' },
        { 'margin-left' => '16px', 'width' => 'calc(50% - 24px)' },
        { 'margin-left' => '16px', 'width' => 'calc(50% - 24px)' },
      ]
    )
  end
end
