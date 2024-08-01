# frozen_string_literal: true

# == Schema Information
# Schema version: 20240727173310
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  lastname               :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user, email: 'EXAMPLE@EMAIL.COM') }

  describe 'AR associations' do
    it { is_expected.to have_many(:assigments) }
    it { is_expected.to have_many(:services).through(:assigments) }
    it { is_expected.to have_many(:availabilities) }
    it { is_expected.to have_many(:shifts) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:confirmation_token).unique }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Instance methods' do
    describe '#full_name' do
      it 'returns name and lastname joined' do
        expect(user.full_name).to eq("#{user.name} #{user.lastname}")
      end
    end

    describe '#downcase_email' do
      it 'returns downcased email' do
        expect(user.email).to eq(user.email.downcase)
      end
    end
  end
end
