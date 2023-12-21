require 'rails_helper'

RSpec.describe RecurringProfile, type: :model do
  describe 'recurring profile' do

    let!(:recurring_profile_1) do
      RecurringProfile.create!(
        frequency: "weekly",
        ends_after_count: 7
      )
    end
    let!(:recurring_profile_2) do
      RecurringProfile.create!(
        frequency: "monthly",
        ends_after_count: 3
      )
    end

    it 'creates recurring invoices by count' do

      expect(Invoice.count).to eq(2)
      expect(recurring_profile_1.invoices.count).to eq(1)
      expect(recurring_profile_1.invoices_count).to eq(1)
      expect(recurring_profile_2.invoices.count).to eq(1)
      expect(recurring_profile_2.invoices_count).to eq(1)
    end

    let!(:recurring_profile_1) do
      RecurringProfile.create!(
        frequency: "weekly",
        ends_on: Date.today + 1.year,
        )
    end
    let!(:recurring_profile_2) do
      RecurringProfile.create!(
        frequency: "yearly",
        ends_on: Date.today + 2.years,
        )
    end

    it 'creates recurring invoices by date' do

      expect(Invoice.count).to eq(2)
      expect(recurring_profile_1.invoices.count).to eq(1)
      expect(recurring_profile_1.invoices_count).to eq(1)
      expect(recurring_profile_2.invoices.count).to eq(1)
      expect(recurring_profile_2.invoices_count).to eq(1)
    end
  end
end
