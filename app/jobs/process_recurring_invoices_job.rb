  # id: integer,
  # subscription_id: integer,
  # number: string,
  # issued_on: date,
  # due_on: date,
  # means_of_payment: string,
  # total: float,
  # created_at: datetime,
  # updated_at: datetime,
  # paid_at: datetime,
  # submitted_at: datetime,
  # deleted_at: datetime,
  # state: ,
  # recurring_profile_id: integer,
  # tax_point_on: date

class ProcessRecurringInvoicesJob < ApplicationJob
  def perform
    recurring_profiles = RecurringProfile.all
    recurring_profiles.each do |recurring_profile|
      recurring_profile.build_invoice
    end
  end
end
