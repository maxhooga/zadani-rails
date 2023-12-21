class RecurringProfile < ActiveRecord::Base
  has_many :invoices, :foreign_key => 'recurring_profile_id'

  attr_accessor :end_options

  validates_presence_of     :frequency
  validates_inclusion_of    :frequency,   in: %w(weekly monthly quaterly halfyearly yearly)
  validates_inclusion_of    :end_options, in: %w(never after_count after_date)
  validates_numericality_of :ends_after_count, greater_than: 0, allow_nil: true, allow_blank: true

  before_save  :handle_end_options
  after_create :build_invoice, if: :should_build_next_one?

  after_update :update_recurring_invoices

  def should_build_next_one?
    if calculate_threshold_date(get_previous_invoice&.issued_on)
      if end_options == 'after_count'
        return invoices_count < ends_after_count
      end
      if end_options == 'after_date'
        return ends_on >= Date.today
      end
      return true
    end
    false
  end

  def calculate_threshold_date(prev_invoice_date)
    return true if invoices.count.zero?

    case frequency
    when 'weekly'
      prev_invoice_date + 1.week == Date.today
    when 'monthly'
      prev_invoice_date + 1.month == Date.today
    when 'quarterly'
      prev_invoice_date + 3.months == Date.today
    when 'halfyearly'
      prev_invoice_date + 6.months == Date.today
    when 'yearly'
      prev_invoice_date + 1.year == Date.today
    else
      false
    end
  end

  def end_options
    if ends_after_count.to_i > 0
      return "after_count"
    end
    if ends_on
      return "after_date"
    end
    "never"
  end

  def build_invoice
    return unless should_build_next_one?

    invoice = Invoice.new(recurring_profile: self)
    self.invoices_count += 1

    invoice.issued_on = Date.today
    if get_previous_invoice.present?
      invoice.number = Invoice.increment_number(get_previous_invoice.number)
    else
      invoice.number = "INV001"
    end

    invoice.submit

    ActiveRecord::Base.transaction do
      self.save!
      invoice.save!
    end
  end

  def get_previous_invoice
    return unless invoices.count.positive?
    invoices.where.not(issued_on: nil).order(issued_on: :desc).first
  end

  protected

  def update_recurring_invoices

  end

  def handle_end_options

  end

end
