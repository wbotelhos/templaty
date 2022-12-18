# frozen_string_literal: true

require 'support/factory_bot'
require 'support/normalizy'
require 'support/shoulda'

RSpec.describe Unit do
  it { expect(build(:unit, slug: :slug).valid?).to be(true) }

  it { is_expected.to normalizy(:description).with :strip }
  it { is_expected.to normalizy(:email).with %i[downcase squish] }
  it { is_expected.to normalizy(:full_name).with :squish }
  it { is_expected.to normalizy(:name).with :squish }
  it { is_expected.to normalizy(:site).with :url }

  it { is_expected.to belong_to(:school).required true }
  it { is_expected.to belong_to(:bot).class_name('User').required false }
  it { is_expected.to belong_to(:owner).class_name('User').required false }

  it { is_expected.to have_one(:payment_account).dependent(:destroy) }
  it { is_expected.to have_one(:subscription).dependent(:destroy) }

  it { is_expected.to have_many(:comments).dependent :restrict_with_error }
  it { is_expected.to have_many(:discounts).dependent :restrict_with_error }
  it { is_expected.to have_many(:events).dependent :restrict_with_error }
  it { is_expected.to have_many(:grades).dependent :restrict_with_error }
  it { is_expected.to have_many(:invoices).dependent :restrict_with_error }
  it { is_expected.to have_many(:payment_methods).dependent :restrict_with_error }
  it { is_expected.to have_many(:products).dependent :restrict_with_error }
  it { is_expected.to have_many(:students).dependent :restrict_with_error }
  it { is_expected.to have_many(:teacher_units).dependent :restrict_with_error }

  it { is_expected.to have_many(:campaigns).dependent(:destroy) }
  it { is_expected.to have_many(:models).dependent(:destroy) }
  it { is_expected.to have_many(:employees).dependent(:destroy) }
  it { is_expected.to have_many(:payment_categories).dependent(:destroy) }
  it { is_expected.to have_many(:roles).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  it { is_expected.to have_many(:unit_qualities).dependent(:destroy) }

  it { is_expected.to have_many(:teachers).through(:teacher_units).dependent :restrict_with_error }
  it { is_expected.to have_many(:qualities).through(:unit_qualities).dependent :restrict_with_error }

  it { is_expected.to accept_nested_attributes_for(:payment_account).allow_destroy(true) }

  it { is_expected.to validate_presence_of(:name) }

  it { expect(create(:unit)).to validate_uniqueness_of(:name).scoped_to(:school_id).case_insensitive }

  it_behaves_like 'addressable' do
    let!(:addressable) { build(:unit) }
  end

  it_behaves_like 'phoneable' do
    let!(:phoneable) { build(:unit) }
  end

  it_behaves_like 'avatar_attached', model_name: :unit
  it_behaves_like 'cover_attached',  model_name: :unit
  it_behaves_like 'photos_attached', model_name: :unit
end
