# frozen_string_literal: true

RSpec.describe Templaty::Helper, '.fields_grid' do
  it do
    expect(<%= params.model_class %>.fields_grid(fields_grid: '100,50:50')).to eq([[100], [50, 50]])
  end
end
