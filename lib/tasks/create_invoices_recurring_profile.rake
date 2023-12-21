namespace :recurring_profiles do
  desc "Create invoices recurring profile"
  task create: :environment do
    ProcessRecurringInvoicesJob.perform_now
  end
end