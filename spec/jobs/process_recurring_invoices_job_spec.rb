require 'rails_helper'

RSpec.describe ProcessRecurringInvoicesJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers
  describe 'process recurring invoices' do

    let!(:recurring_profile_1) do
      RecurringProfile.create!(
        frequency: "weekly",
        ends_after_count: 7
      )
    end

    it 'creates and processes recurring invoices by count' do
      travel_to (Date.today + 1.week).to_time do
        expect(Invoice.count).to eq(1)
        expect(recurring_profile_1.invoices.count).to eq(1)
        expect(recurring_profile_1.invoices.last.number).to eq('INV001')

        ProcessRecurringInvoicesJob.perform_now

        expect(Invoice.count).to eq(2)
        expect(recurring_profile_1.invoices.count).to eq(2)
        expect(recurring_profile_1.invoices.last.number).to eq('INV002')
      end
    end

    let!(:recurring_profile_1) do
      RecurringProfile.create!(
        frequency: "weekly",
        ends_on: Date.today + 1.year,
        )
    end

    it 'creates and processes recurring invoices by count' do
      travel_to (Date.today + 1.week).to_time do
        expect(Invoice.count).to eq(1)
        expect(recurring_profile_1.invoices.count).to eq(1)
        expect(recurring_profile_1.invoices.last.number).to eq('INV001')

        ProcessRecurringInvoicesJob.perform_now

        expect(Invoice.count).to eq(2)
        expect(recurring_profile_1.invoices.count).to eq(2)
        expect(recurring_profile_1.invoices.last.number).to eq('INV002')
      end
    end
  end
end
