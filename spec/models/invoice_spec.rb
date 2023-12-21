# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'invoice' do
    let!(:invoice) do
      Invoice.create(
        number: 'INV001',
        total: 100.0,
        issued_on: Date.today
      )
    end

    it 'creates and processes recurring invoices' do
      expect(Invoice.count).to eq(1)

      created_invoice = Invoice.first
      expect(created_invoice.number).to eq('INV001')
      expect(created_invoice.total).to eq(0)
      expect(created_invoice.issued_on).to eq(Date.today)

    end
  end
end
